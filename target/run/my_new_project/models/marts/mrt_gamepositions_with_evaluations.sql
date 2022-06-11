

  create or replace view `chessthesis`.`chess_thesis`.`mrt_gamepositions_with_evaluations`
  OPTIONS()
  as with analysis as (
    select 
        gp.*, 
        se.best_move as best_move, 
        se.evaluation as evaluation, 
        se.depth as depth,
        se.position_fen as position_fen
    from `chessthesis`.`chess_thesis`.`stg_game_positions` gp
    left join `chessthesis`.`chess_thesis`.`mrt_normalize_stockfish_evaluations` se
    on gp.fen_for_analysis = se.position_fen
)

,

analysis_with_computed_values as (
    select 
        *,
        LAG(eval_diff, 1) OVER (PARTITION BY game_id ORDER BY ply asc) as last_move_eval_diff
    from (
        select 
            *,
            LEAD (evaluation, 1 ) OVER (PARTITION BY game_id ORDER BY ply asc) as post_eval,
            LAG (played_san_move, 1 ) OVER (PARTITION BY game_id ORDER BY ply asc) as last_san_move,
            LAG (played_uci_move, 1 ) OVER (PARTITION BY game_id ORDER BY ply asc) as last_uci_move,
            CASE 
                WHEN white_to_play = True THEN 
                    -1*(evaluation - COALESCE(LEAD (evaluation, 1 ) OVER (PARTITION BY game_id ORDER BY ply asc),0))
                ELSE 
                    evaluation - COALESCE(LEAD (evaluation, 1 ) OVER (PARTITION BY game_id ORDER BY ply asc),0) END 
            AS eval_diff 
        from analysis 
    )


)


select 
    *,
    (CASE 
        WHEN evaluation < 130 AND evaluation > -130 AND post_eval >= 130 AND best_move != played_san_move AND ABS(eval_diff) > 30 THEN "draw->white" 
        WHEN evaluation < 130 AND evaluation > -130 AND post_eval <= -130 AND best_move != played_san_move AND ABS(eval_diff) > 30 THEN "draw->black"
        WHEN evaluation >= 130 AND best_move != played_san_move AND post_eval < 130 AND post_eval > -130 THEN "white->draw"
        WHEN evaluation <= -130 AND best_move != played_san_move AND post_eval < 130 AND post_eval > -130 THEN "black->draw"
        WHEN evaluation >= 130 AND best_move != played_san_move AND post_eval <= -130 THEN "white->black"
        WHEN evaluation <= -130 AND best_move != played_san_move AND post_eval >= 130 THEN "black->white"
    END ) as game_swing, 
from analysis_with_computed_values
--where game_id = 17544
--order by ply asc;

