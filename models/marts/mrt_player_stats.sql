with player_stats_by_game as (
    select 
        game_id,
        (CASE WHEN white_to_play = True THEN 'white' ELSE 'black' END) as player_side, 
        AVG(eval_diff) as avg_diff,
        --PERCENTILE_CONT(eval_diff, 0.5) OVER(PARTITION BY game_id, white_to_play) as median_diff,
        MIN(eval_diff) as worst_move_diff,
        AVG(CASE WHEN ply >= 40 and ply <= 80 THEN eval_diff ELSE NULL END) as avg_eval_diff_midgame,
        SUM(CASE WHEN played_san_move = best_move AND ply > 20 THEN 1 ELSE 0 END) as best_moves,
        SUM(CASE WHEN eval_diff > -10 AND played_san_move != best_move AND ply > 20 THEN 1 ELSE 0 END) as great_moves,
        SUM(CASE WHEN eval_diff > -25 AND eval_diff <= -10 AND played_san_move != best_move AND ply > 20 THEN 1 ELSE 0 END) as good_moves,
        SUM(CASE WHEN eval_diff > -40 AND eval_diff <= -25 AND played_san_move != best_move AND ply > 20 THEN 1 ELSE 0 END) as okay_moves,
        SUM(CASE WHEN eval_diff > -80 AND eval_diff <= -40 AND played_san_move != best_move AND ply > 20 THEN 1 ELSE 0 END) as bad_moves,
        SUM(CASE WHEN eval_diff > -150 AND eval_diff <= -80 AND played_san_move != best_move AND ply > 20 THEN 1 ELSE 0 END) as semi_blunders,
        SUM(CASE WHEN eval_diff <= -150 AND played_san_move != best_move AND ply > 20 THEN 1 ELSE 0 END) as blunders,
        SUM(CASE WHEN ply > 20 THEN 1 ELSE 0 END) as total_moves_post_20_ply,
        SUM(CASE WHEN eval_diff <= -30 AND last_move_eval_diff <= -30 THEN 1 ELSE 0 END) as missed_blunders, --too low value, only for testing
        MIN(CASE WHEN game_swing is not null THEN fullmove_number ELSE NULL END) as first_mistake_at_move,
        MAX(CASE WHEN game_swing is not null THEN fullmove_number ELSE NULL END) as last_mistake_at_move,

        -- game swings by type caused by the player (e.g. white -> draw if he/she is white)
        SUM(CASE 
          WHEN white_to_play = True and game_swing = 'white->draw' THEN 1 
          WHEN white_to_play = False and game_swing = 'black->draw' THEN 1 
          ELSE 0 
        END) as game_swing_win_to_draw,

        SUM(CASE 
          WHEN white_to_play = True and game_swing = 'white->black' THEN 1 
          WHEN white_to_play = False and game_swing = 'black->white' THEN 1 
        ELSE 0 END) as game_swing_win_to_lose,

        SUM(CASE 
          WHEN white_to_play = True and game_swing = 'draw->black' THEN 1 
          WHEN white_to_play = False and game_swing = 'draw->white' THEN 1 
        ELSE 0 END) as game_swing_draw_to_lose,

        -- game swings by game phase (early, earlymid, mid, midlate, late, superlate )
        SUM(CASE WHEN game_swing is not null 
            AND fullmove_number > 0 
            AND fullmove_number <= 10
            --AND white_to_play = False
            THEN 1 ELSE 0 END) as game_swing_early,
        
        SUM(CASE WHEN game_swing is not null 
            AND fullmove_number > 10 
            AND fullmove_number <= 20
            --AND white_to_play = False
            THEN 1 ELSE 0 END) as game_swing_earlymid,
        
        SUM(CASE WHEN game_swing is not null 
            AND fullmove_number > 20 
            AND fullmove_number <= 30
            --AND white_to_play = False
            THEN 1 ELSE 0 END) as game_swing_mid,

        
        SUM(CASE WHEN game_swing is not null 
            AND fullmove_number > 30
            AND fullmove_number <= 40
            THEN 1 ELSE 0 END) as game_swing_midlate,

        SUM(CASE WHEN game_swing is not null 
            AND fullmove_number > 40
            AND fullmove_number <= 60
            THEN 1 ELSE 0 END) as game_swing_late,

        SUM(CASE WHEN game_swing is not null 
            AND fullmove_number > 60
            THEN 1 ELSE 0 END) as game_swing_superlate

    from {{ ref('mrt_gamepositions_with_evaluations') }}
    group by game_id, white_to_play


    /* 
    range of move ranking:
    great: 0 - 0.1
    good : 0.1 - 0.25
    OK   : 0.25 - 0.4
    bad  : 0.4 - 0.8
    semi-blunder: 0.8 - 1.5
    blunder: 1.5 
    */ 
)

,

-- make stats relative to the side (white or black)
players_stats_extended as (
   select 
        (CASE WHEN psbg.player_side = 'white' THEN tg.white_fide_id ELSE tg.black_fide_id END) as player_id,
        (CASE WHEN psbg.player_side = 'white' THEN tg.black_elo ELSE tg.white_elo END) as opponent_rating,
        tg.eco,
        psbg.*,
        best_moves / NULLIF(total_moves_post_20_ply,0) as best_moves_ratio,
        great_moves / NULLIF(total_moves_post_20_ply,0) as great_moves_ratio,
        good_moves / NULLIF(total_moves_post_20_ply,0) as good_moves_ratio,
        okay_moves / NULLIF(total_moves_post_20_ply,0) as okay_moves_ratio,
        bad_moves / NULLIF(total_moves_post_20_ply,0) as bad_moves_ratio,
        semi_blunders / NULLIF(total_moves_post_20_ply,0) as semi_blunders_ratio,
        blunders / NULLIF(total_moves_post_20_ply,0) as blunders_ratio
    from player_stats_by_game psbg
    left join {{ ref('mrt_filtered_twicgames') }} tg on tg.id = psbg.game_id
)

select * 
from players_stats_extended
--where game_id = 17544
--where player_id = 751871
--and game_id = 20132