

with stockfish_eval as (
    select 
        LEFT(string_field_0, LENGTH(string_field_0) - 7 ) as fen,
        CAST(RIGHT(string_field_0, 2) AS int) as depth, 
        RIGHT(string_field_2, LENGTH(string_field_2) - 4) as best_move,
        CAST(
            RIGHT(string_field_3,LENGTH(string_field_3) - 3) AS int
            ) as evaluation
     from `chessthesis`.`chess_thesis`.`stockfish_evaluations`
)

,

order_fens_to_keep_unique as (
  select 
    *,
      CONCAT(
          SPLIT(fen, ' ')[OFFSET(0)], 
          ' ',
          SPLIT(fen, ' ')[OFFSET(1)],
          ' ',
          SPLIT(fen, ' ')[OFFSET(2)],
          ' ',
          SPLIT(fen, ' ')[OFFSET(3)]
        ) as position_fen,
    ROW_NUMBER() OVER (PARTITION BY CONCAT(
          SPLIT(fen, ' ')[OFFSET(0)], 
          ' ',
          SPLIT(fen, ' ')[OFFSET(1)],
          ' ',
          SPLIT(fen, ' ')[OFFSET(2)],
          ' ',
          SPLIT(fen, ' ')[OFFSET(3)]
        ) ORDER BY depth) as RN
  from stockfish_eval
)

select 
  position_fen,
  fen,
  depth,
  best_move,
  evaluation
from order_fens_to_keep_unique
where RN = 1