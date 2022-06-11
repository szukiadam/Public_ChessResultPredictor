with stockfish_evaluations_normalized as (
    select 
        fen, 
        position_fen,
        depth, 
        best_move,
        CASE WHEN REGEXP_CONTAINS(fen, r".*w.*") THEN evaluation ELSE (-1*evaluation) END as normalized_evaluation
    from {{ ref('stg_stockfish_evaluations') }}
)

,

rescale_outliers_evaluations as (
    select 
      * except(normalized_evaluation),
      CASE WHEN normalized_evaluation < -1000 THEN -1000 WHEN normalized_evaluation > 1000 THEN 1000 ELSE normalized_evaluation END as evaluation
    from stockfish_evaluations_normalized
)

select *
from rescale_outliers_evaluations