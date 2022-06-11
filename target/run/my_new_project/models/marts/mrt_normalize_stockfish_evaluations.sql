

  create or replace view `chessthesis`.`chess_thesis`.`mrt_normalize_stockfish_evaluations`
  OPTIONS()
  as with stockfish_evaluations_normalized as (
    select 
        fen, 
        position_fen,
        depth, 
        best_move,
        CASE WHEN REGEXP_CONTAINS(fen, r".*w.*") THEN evaluation ELSE (-1*evaluation) END as normalized_evaluation
    from `chessthesis`.`chess_thesis`.`stg_stockfish_evaluations`
)

,

rescale_outliers_evaluations as (
    select 
      * except(normalized_evaluation),
      CASE WHEN normalized_evaluation < -10000 THEN -10000 WHEN normalized_evaluation > 10000 THEN 10000 ELSE normalized_evaluation END as evaluation
    from stockfish_evaluations_normalized
)

select *
from rescale_outliers_evaluations;

