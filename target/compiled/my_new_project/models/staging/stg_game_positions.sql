

with game_positions as (
    select 
        game_id, 
        position,
        white_to_play,
        white_can_castle_kingside, 
        white_can_castle_queenside,
        black_can_castle_kingside,
        black_can_castle_queenside,
        en_passant_option, 
        halfmove_until_50_move_rule, 
        fullmove_number, 
        played_san_move, 
        played_uci_move,
        complete_fen, 
        --is_analysed, 
        CASE WHEN white_to_play = TRUE THEN (2*fullmove_number)-1 ELSE 2*fullmove_number END as ply,
        SPLIT(complete_fen, ' ')[OFFSET(0)] piece_placement,
        SPLIT(complete_fen, ' ')[OFFSET(1)] active_color,
        SPLIT(complete_fen, ' ')[OFFSET(2)] castling_rights,
        SPLIT(complete_fen, ' ')[OFFSET(3)] en_passant,
        SPLIT(complete_fen, ' ')[OFFSET(4)] halfmove_clock,
        CONCAT(
          SPLIT(complete_fen, ' ')[OFFSET(0)], 
          ' ',
          SPLIT(complete_fen, ' ')[OFFSET(1)],
          ' ',
          SPLIT(complete_fen, ' ')[OFFSET(2)],
          ' ',
          SPLIT(complete_fen, ' ')[OFFSET(3)]
        ) as fen_for_analysis

     from `chessthesis`.`chess_thesis`.`game_positions`
)

,

unique_game_positions as (
  select 
    *,
    ROW_NUMBER() OVER(PARTITION BY game_id, fen_for_analysis) as RN
  from game_positions
)

select *
from unique_game_positions
where RN = 1
--where game_id = 20132
--order by ply asc