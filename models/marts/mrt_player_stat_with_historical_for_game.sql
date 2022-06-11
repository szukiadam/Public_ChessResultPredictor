with player_stat_for_game as (
    select 
        game_id,
        player_id,
        player_side,
        opponent_rating,
        result,

        -- player based features
        COUNT(*) OVER (rolling_three_months) AS games_played_last_three_months,
        COUNT(*) OVER (rolling_six_months) AS games_played_last_six_months,
        COUNT(*) OVER (rolling_twelve_months) AS games_played_last_twelve_months,
        COUNT(*) OVER (rolling_two_years) AS games_played_last_two_years,
        COUNT(*) OVER (rolling_four_years) AS games_played_last_four_years,
        COUNT(*) OVER (rolling_ten_years) AS games_played_last_ten_years,

        --features based on the opponent rating: avg, min, max
        AVG(opponent_rating) OVER (rolling_three_months) AS opponent_rating_avg_last_three_months,
        AVG(opponent_rating) OVER (rolling_six_months) AS opponent_rating_avg_last_six_months,
        AVG(opponent_rating) OVER (rolling_twelve_months) AS opponent_rating_avg_last_twelve_months,
        AVG(opponent_rating) OVER (rolling_two_years) AS opponent_rating_avg_last_two_years,
        AVG(opponent_rating) OVER (rolling_four_years) AS opponent_rating_avg_last_four_years,
        AVG(opponent_rating) OVER (rolling_ten_years) AS opponent_rating_avg_last_ten_years,
        
        MIN(opponent_rating) OVER (rolling_three_months) AS opponent_rating_min_last_three_months,
        MIN(opponent_rating) OVER (rolling_six_months) AS opponent_rating_min_last_six_months,
        MIN(opponent_rating) OVER (rolling_twelve_months) AS opponent_rating_min_last_twelve_months,
        MIN(opponent_rating) OVER (rolling_two_years) AS opponent_rating_min_last_two_years,
        MIN(opponent_rating) OVER (rolling_four_years) AS opponent_rating_min_last_four_years,
        MIN(opponent_rating) OVER (rolling_ten_years) AS opponent_rating_min_last_ten_years,

        MAX(opponent_rating) OVER (rolling_three_months) AS opponent_rating_max_last_three_months,
        MAX(opponent_rating) OVER (rolling_six_months) AS opponent_rating_max_last_six_months,
        MAX(opponent_rating) OVER (rolling_twelve_months) AS opponent_rating_max_last_twelve_months,
        MAX(opponent_rating) OVER (rolling_two_years) AS opponent_rating_max_last_two_years,
        MAX(opponent_rating) OVER (rolling_four_years) AS opponent_rating_max_last_four_years,
        MAX(opponent_rating) OVER (rolling_ten_years) AS opponent_rating_max_last_ten_years,

        --calculate performances 
        COALESCE(SUM(CASE 
                WHEN result = '1-0' THEN opponent_rating+400 
                ELSE opponent_rating-400 END 
            ) OVER(rolling_three_months)
            / 
            NULLIF(COUNT(result) OVER(rolling_three_months),0),0) as rolling_three_months_performance,

        COALESCE(SUM(CASE 
                WHEN result = '1-0' THEN opponent_rating+400 
                ELSE opponent_rating-400 END 
            ) OVER(rolling_six_months)
            / 
            NULLIF(COUNT(result) OVER(rolling_six_months),0),0) as rolling_six_months_performance,

        COALESCE(SUM(CASE 
                WHEN result = '1-0' THEN opponent_rating+400 
                ELSE opponent_rating-400 END 
            ) OVER(rolling_twelve_months)
            / 
            NULLIF(COUNT(result) OVER(rolling_twelve_months),0),0) as rolling_twelve_months_performance,

        COALESCE(SUM(CASE 
                WHEN result = '1-0' THEN opponent_rating+400 
                ELSE opponent_rating-400 END
            ) OVER(rolling_two_years)
            / 
            NULLIF(COUNT(result) OVER(rolling_two_years),0),0) as rolling_two_years_performance,

        COALESCE(SUM(CASE 
                WHEN result = '1-0' THEN opponent_rating+400 
                ELSE opponent_rating-400 END 
            ) OVER(rolling_four_years)
            / 
            NULLIF(COUNT(result) OVER(rolling_four_years),0),0) as rolling_four_years_performance,

        COALESCE(SUM(CASE 
                WHEN result = '1-0' THEN opponent_rating+400 
                ELSE opponent_rating-400 END 
            ) OVER(rolling_ten_years)
            / 
            NULLIF(COUNT(result) OVER(rolling_ten_years),0),0) as rolling_ten_years_performance,

        --features based on the game
        AVG(avg_eval_diff_midgame) OVER(rolling_three_months) as avg_eval_diff_last_three_months,
        AVG(avg_eval_diff_midgame) OVER(rolling_six_months) as avg_eval_diff_last_six_months,
        AVG(avg_eval_diff_midgame) OVER(rolling_twelve_months) as avg_eval_diff_last_twelve_months,
        AVG(avg_eval_diff_midgame) OVER(rolling_two_years) as avg_eval_diff_last_two_years,
        AVG(avg_eval_diff_midgame) OVER(rolling_four_years) as avg_eval_diff_last_four_years,
        AVG(avg_eval_diff_midgame) OVER(rolling_ten_years) as avg_eval_diff_last_ten_years,
        
        AVG(best_moves_ratio) OVER(rolling_three_months) as best_moves_ratio_last_three_months,
        AVG(best_moves_ratio) OVER(rolling_six_months) as best_moves_ratio_last_six_months,
        AVG(best_moves_ratio) OVER(rolling_twelve_months) as best_moves_ratio_last_twelve_months,
        AVG(best_moves_ratio) OVER(rolling_two_years) as best_moves_ratio_last_two_years,
        AVG(best_moves_ratio) OVER(rolling_four_years) as best_moves_ratio_last_four_years,
        AVG(best_moves_ratio) OVER(rolling_ten_years) as best_moves_ratio_last_ten_years,

        AVG(great_moves_ratio) OVER(rolling_three_months) as great_moves_ratio_last_three_months,
        AVG(great_moves_ratio) OVER(rolling_six_months) as great_moves_ratio_last_six_months,
        AVG(great_moves_ratio) OVER(rolling_twelve_months) as great_moves_ratio_last_twelve_months,
        AVG(great_moves_ratio) OVER(rolling_two_years) as great_moves_ratio_last_two_years,
        AVG(great_moves_ratio) OVER(rolling_four_years) as great_moves_ratio_last_four_years,
        AVG(great_moves_ratio) OVER(rolling_ten_years) as great_moves_ratio_last_ten_years,
        
        AVG(good_moves_ratio) OVER(rolling_three_months) as good_moves_ratio_last_three_months,
        AVG(good_moves_ratio) OVER(rolling_six_months) as good_moves_ratio_last_six_months,
        AVG(good_moves_ratio) OVER(rolling_twelve_months) as good_moves_ratio_last_twelve_months,
        AVG(good_moves_ratio) OVER(rolling_two_years) as good_moves_ratio_last_two_years,
        AVG(good_moves_ratio) OVER(rolling_four_years) as good_moves_ratio_last_four_years,
        AVG(good_moves_ratio) OVER(rolling_ten_years) as good_moves_ratio_last_ten_years,

        AVG(okay_moves_ratio) OVER(rolling_three_months) as okay_moves_ratio_last_three_months,
        AVG(okay_moves_ratio) OVER(rolling_six_months) as okay_moves_ratio_last_six_months,
        AVG(okay_moves_ratio) OVER(rolling_twelve_months) as okay_moves_ratio_last_twelve_months,
        AVG(okay_moves_ratio) OVER(rolling_two_years) as okay_moves_ratio_last_two_years,
        AVG(okay_moves_ratio) OVER(rolling_four_years) as okay_moves_ratio_last_four_years,
        AVG(okay_moves_ratio) OVER(rolling_ten_years) as okay_moves_ratio_last_ten_years,

        AVG(bad_moves_ratio) OVER(rolling_three_months) as bad_moves_ratio_last_three_months,
        AVG(bad_moves_ratio) OVER(rolling_six_months) as bad_moves_ratio_last_six_months,
        AVG(bad_moves_ratio) OVER(rolling_twelve_months) as bad_moves_ratio_last_twelve_months,
        AVG(bad_moves_ratio) OVER(rolling_two_years) as bad_moves_ratio_last_two_years,
        AVG(bad_moves_ratio) OVER(rolling_four_years) as bad_moves_ratio_last_four_years,
        AVG(bad_moves_ratio) OVER(rolling_ten_years) as bad_moves_ratio_last_ten_years,

        AVG(semi_blunders_ratio) OVER(rolling_three_months) as semi_blunders_ratio_last_three_months,
        AVG(semi_blunders_ratio) OVER(rolling_six_months) as semi_blunders_ratio_last_six_months,
        AVG(semi_blunders_ratio) OVER(rolling_twelve_months) as semi_blunders_ratio_last_twelve_months,
        AVG(semi_blunders_ratio) OVER(rolling_two_years) as semi_blunders_ratio_last_two_years,
        AVG(semi_blunders_ratio) OVER(rolling_four_years) as semi_blunders_ratio_last_four_years,
        AVG(semi_blunders_ratio) OVER(rolling_ten_years) as semi_blunders_ratio_last_ten_years,

        AVG(blunders_ratio) OVER(rolling_three_months) as blunders_ratio_last_three_months,
        AVG(blunders_ratio) OVER(rolling_six_months) as blunders_ratio_last_six_months,
        AVG(blunders_ratio) OVER(rolling_twelve_months) as blunders_ratio_last_twelve_months,
        AVG(blunders_ratio) OVER(rolling_two_years) as blunders_ratio_last_two_years,
        AVG(blunders_ratio) OVER(rolling_four_years) as blunders_ratio_last_four_years,
        AVG(blunders_ratio) OVER(rolling_ten_years) as blunders_ratio_last_ten_years,

        AVG(game_length) OVER(rolling_three_months) as game_length_avg_last_three_months,
        AVG(game_length) OVER(rolling_six_months) as game_length_avg_last_six_months,
        AVG(game_length) OVER(rolling_twelve_months) as game_length_avg_last_twelve_months,
        AVG(game_length) OVER(rolling_two_years) as game_length_avg_last_two_years,
        AVG(game_length) OVER(rolling_four_years) as game_length_avg_last_four_years,
        AVG(game_length) OVER(rolling_ten_years) as game_length_avg_last_ten_years,

        MIN(game_length) OVER(rolling_three_months) as game_length_min_last_three_months,
        MIN(game_length) OVER(rolling_six_months) as game_length_min_last_six_months,
        MIN(game_length) OVER(rolling_twelve_months) as game_length_min_last_twelve_months,
        MIN(game_length) OVER(rolling_two_years) as game_length_min_last_two_years,
        MIN(game_length) OVER(rolling_four_years) as game_length_min_last_four_years,
        MIN(game_length) OVER(rolling_ten_years) as game_length_min_last_ten_years,

        MIN(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_three_months) as relative_opening_eval_10_last_three_months_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_six_months) as relative_opening_eval_10_last_six_months_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_twelve_months) as relative_opening_eval_10_last_twelve_months_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_two_years) as relative_opening_eval_10_last_two_years_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_four_years) as relative_opening_eval_10_last_four_years_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_ten_years) as relative_opening_eval_10_last_ten_years_min,
        MAX(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_three_months) as relative_opening_eval_10_last_three_months_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_six_months) as relative_opening_eval_10_last_six_months_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_twelve_months) as relative_opening_eval_10_last_twelve_months_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_two_years) as relative_opening_eval_10_last_two_years_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_four_years) as relative_opening_eval_10_last_four_years_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_ten_years) as relative_opening_eval_10_last_ten_years_max,
        AVG(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_three_months) as relative_opening_eval_10_last_three_months_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_six_months) as relative_opening_eval_10_last_six_months_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_twelve_months) as relative_opening_eval_10_last_twelve_months_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_two_years) as relative_opening_eval_10_last_two_years_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_four_years) as relative_opening_eval_10_last_four_years_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_10 ELSE -1*eval_10 END) OVER(rolling_ten_years) as relative_opening_eval_10_last_ten_years_avg,

        MIN(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_three_months) as relative_opening_eval_15_last_three_months_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_six_months) as relative_opening_eval_15_last_six_months_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_twelve_months) as relative_opening_eval_15_last_twelve_months_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_two_years) as relative_opening_eval_15_last_two_years_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_four_years) as relative_opening_eval_15_last_four_years_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_ten_years) as relative_opening_eval_15_last_ten_years_min,
        MAX(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_three_months) as relative_opening_eval_15_last_three_months_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_six_months) as relative_opening_eval_15_last_six_months_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_twelve_months) as relative_opening_eval_15_last_twelve_months_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_two_years) as relative_opening_eval_15_last_two_years_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_four_years) as relative_opening_eval_15_last_four_years_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_ten_years) as relative_opening_eval_15_last_ten_years_max,
        AVG(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_three_months) as relative_opening_eval_15_last_three_months_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_six_months) as relative_opening_eval_15_last_six_months_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_twelve_months) as relative_opening_eval_15_last_twelve_months_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_two_years) as relative_opening_eval_15_last_two_years_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_four_years) as relative_opening_eval_15_last_four_years_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_15 ELSE -1*eval_15 END) OVER(rolling_ten_years) as relative_opening_eval_15_last_ten_years_avg,

        MIN(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_three_months) as relative_opening_eval_20_last_three_months_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_six_months) as relative_opening_eval_20_last_six_months_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_twelve_months) as relative_opening_eval_20_last_twelve_months_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_two_years) as relative_opening_eval_20_last_two_years_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_four_years) as relative_opening_eval_20_last_four_years_min,
        MIN(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_ten_years) as relative_opening_eval_20_last_ten_years_min,
        MAX(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_three_months) as relative_opening_eval_20_last_three_months_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_six_months) as relative_opening_eval_20_last_six_months_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_twelve_months) as relative_opening_eval_20_last_twelve_months_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_two_years) as relative_opening_eval_20_last_two_years_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_four_years) as relative_opening_eval_20_last_four_years_max,
        MAX(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_ten_years) as relative_opening_eval_20_last_ten_years_max,
        AVG(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_three_months) as relative_opening_eval_20_last_three_months_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_six_months) as relative_opening_eval_20_last_six_months_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_twelve_months) as relative_opening_eval_20_last_twelve_months_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_two_years) as relative_opening_eval_20_last_two_years_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_four_years) as relative_opening_eval_20_last_four_years_avg,
        AVG(CASE WHEN player_side = 'white' THEN eval_20 ELSE -1*eval_20 END) OVER(rolling_ten_years) as relative_opening_eval_20_last_ten_years_avg
        
    from (
        select 
            ps.*,
            tg.result,
            gs.game_length,
            gs.eval_10,
            gs.eval_15,
            gs.eval_20,
            DATE_DIFF(tg.date, '2010-01-01', MONTH) month_pos,
            AVG(avg_diff) OVER (PARTITION BY player_id ORDER BY tg.year, tg.month, tg.day rows between 1 preceding and 1 preceding) as avg_diff_last_3_games,
            AVG(avg_diff) OVER (PARTITION BY player_id ORDER BY tg.year, tg.month, tg.day rows current row ) as avg_current,
            
        from {{ ref('stg_twicgames') }} tg  
        inner join {{ ref('mrt_player_stats') }} ps on ps.game_id = tg.id
        inner join {{ ref('mrt_game_stats') }} gs on gs.game_id = tg.id
        --where player_id = 751871
        --order by year, month asc
            
    )

    -- window functions for player_id
    WINDOW rolling_three_months AS 
    (PARTITION BY player_id ORDER BY month_pos RANGE BETWEEN 3 PRECEDING AND 1 PRECEDING )

    , rolling_six_months AS 
    (PARTITION BY player_id ORDER BY month_pos RANGE BETWEEN 6 PRECEDING AND 1 PRECEDING )

    , rolling_twelve_months AS 
    (PARTITION BY player_id ORDER BY month_pos RANGE BETWEEN 12 PRECEDING AND 1 PRECEDING )

    , rolling_two_years AS 
    (PARTITION BY player_id ORDER BY month_pos RANGE BETWEEN 24 PRECEDING AND 1 PRECEDING )

    , rolling_four_years AS 
    (PARTITION BY player_id ORDER BY month_pos RANGE BETWEEN 48 PRECEDING AND 1 PRECEDING )

    , rolling_ten_years AS 
    (PARTITION BY player_id ORDER BY month_pos RANGE BETWEEN 120 PRECEDING AND 1 PRECEDING )

)

select * 
from player_stat_for_game
--where game_id = 20132
--where game_id is not null



