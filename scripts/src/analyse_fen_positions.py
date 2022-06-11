import traceback
import itertools
import requests
import asyncio
import chess
import chess.engine
from pprint import pprint

async def get_engine_eval_for_position(position, engine_path):
    try:
        _, engine = await chess.engine.popen_uci(engine_path)

        ##  await engine.setoption({"Threads": 4})

        board = chess.Board(position)
        info = await engine.analyse(board, chess.engine.Limit(depth=22))
#        pprint(info["score"])

    finally:
        await engine.quit()

    return info["score"]

def curl_to_json(url):
    try:
        res = requests.get(url)
        res_json = res.json()

        return res_json
    except Exception as e:
        print(f"Error occurred in curl_to_json, Error: {e}")

def get_lichess_cloud_eval_for_position(fen):
    """
    Gets the cloud evaluation from lichess. A lot of positions are not in the database.

    API endpoint usage example: https://lichess.org/api/cloud-eval?fen=rnbqkbnr/pp2pppp/8/2ppP3/2P5/8/PP1P1PPP/RNBQKBNR%20b%20KQkq%20-%200%203

    Returns a dictionary with the following keys:
        - fen
        - knodes
        - depth
        - pvs (array containing dictionaries)
            - moves (in san format)
            - cp
    """
    try:
        res_json = curl_to_json(f"https://lichess.org/api/cloud-eval?fen={fen}")

        if "error" in res_json.keys():
            return None
        else:
            return res_json
    except Exception as e:
        print(f"Couldn't get cloud evaluation from lichess for position {fen}, Error: {e}")


def get_lichess_masters_database_info(fen):
    """
    Uses the following endpoint: https://explorer.lichess.ovh/masters
    Return information about a given position using the masters database from lichess.
    Returns:
        - white (wins)
        - draws
        - black (wins)
        - moves (array)
            - uci
            - san
            - average_rating
            - white
            - draws
            - black
        - top_games
            - winner (e.g. "white", null, black)
            - month (format: 2019-08)
        - opening (can be null)

    """
    try:
        res_json = curl_to_json(f"https://explorer.lichess.ovh/masters?fen={fen}")

        return res_json

    except Exception as e:
        print(f"Error occurred in get_lichess_masters_database_info, Error: {e}")

        return None


def get_lichess_all_database_info(fen):
    """
    Uses the following endpoint: https://explorer.lichess.ovh/lichess
    Return information about a given position using the masters database from lichess.

    Example: curl https://explorer.lichess.ovh/lichess?variant=standard&speeds=blitz,rapid,classical&ratings=2200,2500&fen=rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR%20w%20KQkq%20-%200%201

    Inputs:
        - fen
        - speeds (blitz, rapid, correspondence, classical)
        - ratings (specifies rating group)

    Returns:
        - white (wins)
        - draws
        - black (wins)
        - moves (array)
            - uci
            - san
            - average_rating
            - white
            - draws
            - black
        - top_games
            - winner (e.g. "white", null, black)
            - month (format: 2019-08)
        - opening (can be null)
    """
    try:
        # generate all pairs of the input space
        parameters = [['blitz', 'rapid', 'correspondence', 'classical'], [(1600,1800),(1800,2000), (2000,2200), (2200, 2500), (2500,2500)]]
        tuple_pairs = list(itertools.product(*parameters))

        fields_to_keep = ['white', 'black', 'draws']

        summary_dict = {}
        for pair in tuple_pairs:

            speed_variant = pair[0]
            rating_min = pair[1][0]
            rating_max = pair[1][1]

            res_json = curl_to_json(f"https://explorer.lichess.ovh/lichess?fen={fen}&speeds={speed_variant}&ratings={rating_min},{rating_max}")
            pair_dict = {f"{speed_variant}_{rating_min}_{rating_max}_{key}": res_json[key] for key in fields_to_keep}
            summary_dict.update(pair_dict)

        return summary_dict

    except Exception as e:
        print(f"Error occurred in get_lichess_masters_database_info, Error: {e}, Long error: {traceback.print_exc()}")

        return None


if __name__=='__main__':
    # asyncio.set_event_loop_policy(chess.engine.EventLoopPolicy())
    # res = asyncio.run(get_engine_eval_for_position('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1', '../stockfish_14_linux_x64_ssse/stockfish_14_x64_ssse'))

    #pprint(get_lichess_cloud_eval_for_position('rrrnbqkbnr/pp2pppp/8/2ppP3/2P5/8/PP1P1PPP/RNBQKBNR%20b%20KQkq%20-%200%203'))
    pprint(get_lichess_all_database_info('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'))
