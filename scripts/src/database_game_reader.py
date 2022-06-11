import datetime
from pickletools import int4
import pandas as pd
import csv
from pprint import pprint
import psycopg2
import io
import chess
import chess.pgn
import configparser
import os
import psycopg2.extras
from google.cloud import bigquery
from google.oauth2 import service_account
import boto3

def extract_positions(moves_string):
    try:
        pgn = io.StringIO(moves_string)
        game = chess.pgn.read_game(pgn)

        board = game.board()
        for move in game.mainline_moves():

            san_move = board.san(move)
            uci_move = move.uci()

            yield (board.fen(), san_move, uci_move)
            board.push(move)

    except Exception as e:
        print(f"Error while iterating over game. Move_string:  {moves_string}, Error: {e}")
        return None


def fen_set_after_pos(set_):
    return lambda fen: set_.add(pos_from_fen(fen))


def get_ids_from_extracted_fen_csv(filename):
    try:
        df = pd.read_csv(filename, usecols=['game_id'])
        df = df[df["game_id"] != "game_id"]
        return df['game_id'].astype(float).values
    except Exception as e:
        pprint(f"Error occured while extracting ids from the csv file. Error: {e}")
        nans=df["game_id"].astype(float, errors='ignore').isna()
        print(df.loc[nans, 'game_id'].tolist())

def transform_fen(fen_string):
    """
    Transform a FEN string into meaningful features.
    FEN example: rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1
    Meaning: position | side to play | white castling options , black castling options
                      | possible en passant target | halfmove until 50 (100) | fullmove
    """

    fen_parts = fen_string.split()

    fen_dict = {}
    fen_dict["position"] = fen_parts[0]
    fen_dict["white_to_play"] = True if fen_parts[1]=='w' else False
    fen_dict["complete_fen"] = fen_string

    if fen_parts[2] == '--':
        fen_dict["white_can_castle_kingside"], fen_dict["white_can_castle_queenside"], fen_dict["black_can_castle_kingside"], fen_dict["black_can_castle_queenside"] = False, False, False, False

        fen_dict["en_passant_option"] = None
        fen_dict["halfmove_until_50_move_rule"] = fen_parts[3] if fen_parts[3] != '-' else None
        fen_dict["fullmove_number"] = fen_parts[4] if fen_parts[4] != '-' else None

    else:
        fen_dict["white_can_castle_kingside"] = True if 'K' in fen_parts[2] else False
        fen_dict["white_can_castle_queenside"] = True if 'Q' in fen_parts[2] else False
        fen_dict["black_can_castle_kingside"] = True if 'k' in fen_parts[2] else False
        fen_dict["black_can_castle_queenside"] = True if 'q' in fen_parts[2] else False

        fen_dict["en_passant_option"] = fen_parts[3] if fen_parts[3] != '-' else None
        fen_dict["halfmove_until_50_move_rule"] = fen_parts[4] if fen_parts[4] != '-' else None
        fen_dict["fullmove_number"] = fen_parts[5] if fen_parts[5] != '-' else None

    return fen_dict


def get_connection(file, content):

    parser = configparser.ConfigParser()
    parser.read('pipeline.ini')

    dbname = parser.get(content, "database")
    user = parser.get(content, "username")
    password = parser.get(content, "password")
    host = parser.get(content, "host")
    port = parser.get(content, "port")

    # Connect to the Local postgres db
    rs_conn = psycopg2.connect(
        "dbname=" + dbname
        + " user=" + user
        + " password=" + password
        + " host=" + host
        + " port=" + port)

    return rs_conn


def query_bigquery(query_string):
    """Connects to BigQuery and runs the passed query. Returns the result of the query.

    Args:
        query_string (string): The SQL query itself.

    Returns:
        results: The result of the passed query.
    """


    credentials = service_account.Credentials.from_service_account_file(
        '../../config/chessthesis_service_account.json', scopes=["https://www.googleapis.com/auth/cloud-platform"],
    )

    client = bigquery.Client(credentials=credentials)
    query_job = client.query(
        query_string
    )

    results = query_job.result()

    return results

def write_to_file(content_list, output_file):
    for item in content_list:
        with open(output_file, 'a') as out:
            out.write(item.fen_for_analysis + '\n')


def bigquery_get_positions(output_file='positions.epd'):
    """Writes out the positions that are in the game_positions table to a (.epd) file."""

    query = """
    select distinct fen_for_analysis
    from chess_thesis.stg_game_positions
    where fen_for_analysis not in (
        select distinct position_fen
        from `chessthesis.chess_thesis.stg_stockfish_evaluations`
    )
    """
    res = query_bigquery(query)
    write_to_file(res, output_file)


def generate_game_positions_for_player_id(player_id):
    """
    This function generates the games positions for all the games of the given player.
    Creates a csv file which contains all the positions that have arised during the games.

    Args:
        player_id (int): The Fide ID of the player.
    """

    # rs_conn = get_connection('pipeline.ini', 'Local')
    # cur = rs_conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)


    if player_id:
        query = f"""
            select
                id,
                moves
            from chess_thesis.stg_twicgames
            where moves is not NULL
            and moves != ''
            and white_fide_id = {player_id}
            or black_fide_id = {player_id}
            """
    else:
        query = f"""
            select
                id,
                moves
            from chess_thesis.mrt_filtered_twicgames tg
            inner join chess_thesis.fide_players fp_white on fp_white.fide_id = tg.white_fide_id
            inner join chess_thesis.fide_players fp_black on fp_black.fide_id = tg.black_fide_id
            where fp_white.federation = 'HUN'
            and fp_black.federation = 'HUN'
            """

    games = query_bigquery(query)

    positions_with_gameid = []
    for item in games:
        generated_positions = extract_positions(item["moves"])

        if generated_positions is None:
            continue

        position_transformed = []
        for position in generated_positions:

            # Transform the FEN positions string into a dictionary with different keys
            position_transformed_dict = transform_fen(position[0])

            position_transformed_dict["game_id"] = item["id"]
            position_transformed_dict["played_san_move"] = position[1]
            position_transformed_dict["played_uci_move"] = position[2]

            positions_with_gameid.append(position_transformed_dict)


    # Write out the list of dictionaries into a csv file
    with open('game_positions.csv', 'a', newline='') as out:
        fieldnames = positions_with_gameid[0].keys()
        writer = csv.DictWriter(out, fieldnames = fieldnames)
        writer.writeheader()
        for row in positions_with_gameid:
            writer.writerow(row)

    gameids = get_ids_from_extracted_fen_csv('game_positions.csv')
    update_extracted_games_query = f"""
        update twicgames
        set is_fen_extracted = True
        where id in %(gameids)s
        """

    # Update those records in the twicgames table whose positions have been extracted
    #cur.execute(update_extracted_games_query, {
    #    'gameids': tuple(gameids),
    #})

    cols = positions_with_gameid[0].keys()
    insert_query = """
        insert into game_positions ({}) values %s'.format(','.join(cols))
        """

    # Convert positions values to sequence of seqeences
    values = [[value for value in item.values()] for item in positions_with_gameid]

    #psycopg2.extras.execute_values(
    #    cur, insert_query, values, template=None
    #)

    #cur.close()

    #rs_conn.commit()
    #rs_conn.close()

def query_positions():
    query = """
        select distinct complete_fen
        from chess_thesis.game_positions
        limit 100
    """

    positions = query_bigquery(query)

    lambda_client = boto3.client('lambda')
    for pos in positions:
        lambda_client.invoke(
            FunctionName='myfunctionname',
            InvocationType='Event'|'RequestResponse'|'DryRun',
            LogType='None'|'Tail',
            ClientContext=pos,
            Payload={"position": pos},
            Qualifier='string'
        )


if __name__ == '__main__':

    # generate_game_positions_for_player_id(None)
    bigquery_get_positions()
    # bigquery_test()

    # pprint(transform_fen('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b -- 0 1'))

