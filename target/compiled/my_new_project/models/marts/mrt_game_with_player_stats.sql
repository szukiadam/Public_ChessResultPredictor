select 
    *,
    
    -- eco based features
    COUNT(eco) OVER(rolling_eco_three_months) as eco_games_last_three_months,
    SUM(CASE WHEN result = '1-0' THEN 1 ELSE 0 END) OVER(rolling_eco_three_months) as white_win_count,
    SUM(CASE WHEN result = '0-1' THEN 1 ELSE 0 END) OVER(rolling_eco_three_months) as black_win_count,
    SUM(CASE WHEN result = '1/2-1/2' THEN 1 ELSE 0 END) OVER(rolling_eco_three_months) as draw_count,

    -- player based features
    COUNT(*) OVER (rolling_three_months) AS games_played_last_three_months,
    COUNT(*) OVER (rolling_six_months) AS games_played_last_six_months,
    COUNT(*) OVER (rolling_twelve_months) AS games_played_last_twelve_months,
    COUNT(*) OVER (rolling_two_years) AS games_played_last_two_years,
    COUNT(*) OVER (rolling_four_years) AS games_played_last_four_years,
    COUNT(*) OVER (rolling_ten_years) AS games_played_last_ten_years,

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

    AVG(total_moves) OVER(rolling_three_months) as total_moves_avg_last_three_months,
    AVG(total_moves) OVER(rolling_six_months) as total_moves_avg_last_six_months,
    AVG(total_moves) OVER(rolling_twelve_months) as total_moves_avg_last_twelve_months,
    AVG(total_moves) OVER(rolling_two_years) as total_moves_avg_last_two_years,
    AVG(total_moves) OVER(rolling_four_years) as total_moves_avg_last_four_years,
    AVG(total_moves) OVER(rolling_ten_years) as total_moves_avg_last_ten_years,

    MIN(total_moves) OVER(rolling_three_months) as total_moves_min_last_three_months,
    MIN(total_moves) OVER(rolling_six_months) as total_moves_min_last_six_months,
    MIN(total_moves) OVER(rolling_twelve_months) as total_moves_min_last_twelve_months,
    MIN(total_moves) OVER(rolling_two_years) as total_moves_min_last_two_years,
    MIN(total_moves) OVER(rolling_four_years) as total_moves_min_last_four_years,
    MIN(total_moves) OVER(rolling_ten_years) as total_moves_min_last_ten_years,

    MIN(relative_opening_eval_10) OVER(rolling_three_months) as relative_opening_eval_10_last_three_months_min,
    MIN(relative_opening_eval_10) OVER(rolling_six_months) as relative_opening_eval_10_last_six_months_min,
    MIN(relative_opening_eval_10) OVER(rolling_twelve_months) as relative_opening_eval_10_last_twelve_months_min,
    MIN(relative_opening_eval_10) OVER(rolling_two_years) as relative_opening_eval_10_last_two_years_min,
    MIN(relative_opening_eval_10) OVER(rolling_four_years) as relative_opening_eval_10_last_four_years_min,
    MIN(relative_opening_eval_10) OVER(rolling_ten_years) as relative_opening_eval_10_last_ten_years_min,
    MAX(relative_opening_eval_10) OVER(rolling_three_months) as relative_opening_eval_10_last_three_months_max,
    MAX(relative_opening_eval_10) OVER(rolling_six_months) as relative_opening_eval_10_last_six_months_max,
    MAX(relative_opening_eval_10) OVER(rolling_twelve_months) as relative_opening_eval_10_last_twelve_months_max,
    MAX(relative_opening_eval_10) OVER(rolling_two_years) as relative_opening_eval_10_last_two_years_max,
    MAX(relative_opening_eval_10) OVER(rolling_four_years) as relative_opening_eval_10_last_four_years_max,
    MAX(relative_opening_eval_10) OVER(rolling_ten_years) as relative_opening_eval_10_last_ten_years_max,
    AVG(relative_opening_eval_10) OVER(rolling_three_months) as relative_opening_eval_10_last_three_months_avg,
    AVG(relative_opening_eval_10) OVER(rolling_six_months) as relative_opening_eval_10_last_six_months_avg,
    AVG(relative_opening_eval_10) OVER(rolling_twelve_months) as relative_opening_eval_10_last_twelve_months_avg,
    AVG(relative_opening_eval_10) OVER(rolling_two_years) as relative_opening_eval_10_last_two_years_avg,
    AVG(relative_opening_eval_10) OVER(rolling_four_years) as relative_opening_eval_10_last_four_years_avg,
    AVG(relative_opening_eval_10) OVER(rolling_ten_years) as relative_opening_eval_10_last_ten_years_avg,

    MIN(relative_opening_eval_15) OVER(rolling_three_months) as relative_opening_eval_15_last_three_months_min,
    MIN(relative_opening_eval_15) OVER(rolling_six_months) as relative_opening_eval_15_last_six_months_min,
    MIN(relative_opening_eval_15) OVER(rolling_twelve_months) as relative_opening_eval_15_last_twelve_months_min,
    MIN(relative_opening_eval_15) OVER(rolling_two_years) as relative_opening_eval_15_last_two_years_min,
    MIN(relative_opening_eval_15) OVER(rolling_four_years) as relative_opening_eval_15_last_four_years_min,
    MIN(relative_opening_eval_15) OVER(rolling_ten_years) as relative_opening_eval_15_last_ten_years_min,
    MAX(relative_opening_eval_15) OVER(rolling_three_months) as relative_opening_eval_15_last_three_months_max,
    MAX(relative_opening_eval_15) OVER(rolling_six_months) as relative_opening_eval_15_last_six_months_max,
    MAX(relative_opening_eval_15) OVER(rolling_twelve_months) as relative_opening_eval_15_last_twelve_months_max,
    MAX(relative_opening_eval_15) OVER(rolling_two_years) as relative_opening_eval_15_last_two_years_max,
    MAX(relative_opening_eval_15) OVER(rolling_four_years) as relative_opening_eval_15_last_four_years_max,
    MAX(relative_opening_eval_15) OVER(rolling_ten_years) as relative_opening_eval_15_last_ten_years_max,
    AVG(relative_opening_eval_15) OVER(rolling_three_months) as relative_opening_eval_15_last_three_months_avg,
    AVG(relative_opening_eval_15) OVER(rolling_six_months) as relative_opening_eval_15_last_six_months_avg,
    AVG(relative_opening_eval_15) OVER(rolling_twelve_months) as relative_opening_eval_15_last_twelve_months_avg,
    AVG(relative_opening_eval_15) OVER(rolling_two_years) as relative_opening_eval_15_last_two_years_avg,
    AVG(relative_opening_eval_15) OVER(rolling_four_years) as relative_opening_eval_15_last_four_years_avg,
    AVG(relative_opening_eval_15) OVER(rolling_ten_years) as relative_opening_eval_15_last_ten_years_avg,

    MIN(relative_opening_eval_20) OVER(rolling_three_months) as relative_opening_eval_20_last_three_months_min,
    MIN(relative_opening_eval_20) OVER(rolling_six_months) as relative_opening_eval_20_last_six_months_min,
    MIN(relative_opening_eval_20) OVER(rolling_twelve_months) as relative_opening_eval_20_last_twelve_months_min,
    MIN(relative_opening_eval_20) OVER(rolling_two_years) as relative_opening_eval_20_last_two_years_min,
    MIN(relative_opening_eval_20) OVER(rolling_four_years) as relative_opening_eval_20_last_four_years_min,
    MIN(relative_opening_eval_20) OVER(rolling_ten_years) as relative_opening_eval_20_last_ten_years_min,
    MAX(relative_opening_eval_20) OVER(rolling_three_months) as relative_opening_eval_20_last_three_months_max,
    MAX(relative_opening_eval_20) OVER(rolling_six_months) as relative_opening_eval_20_last_six_months_max,
    MAX(relative_opening_eval_20) OVER(rolling_twelve_months) as relative_opening_eval_20_last_twelve_months_max,
    MAX(relative_opening_eval_20) OVER(rolling_two_years) as relative_opening_eval_20_last_two_years_max,
    MAX(relative_opening_eval_20) OVER(rolling_four_years) as relative_opening_eval_20_last_four_years_max,
    MAX(relative_opening_eval_20) OVER(rolling_ten_years) as relative_opening_eval_20_last_ten_years_max,
    AVG(relative_opening_eval_20) OVER(rolling_three_months) as relative_opening_eval_20_last_three_months_avg,
    AVG(relative_opening_eval_20) OVER(rolling_six_months) as relative_opening_eval_20_last_six_months_avg,
    AVG(relative_opening_eval_20) OVER(rolling_twelve_months) as relative_opening_eval_20_last_twelve_months_avg,
    AVG(relative_opening_eval_20) OVER(rolling_two_years) as relative_opening_eval_20_last_two_years_avg,
    AVG(relative_opening_eval_20) OVER(rolling_four_years) as relative_opening_eval_20_last_four_years_avg,
    AVG(relative_opening_eval_20) OVER(rolling_ten_years) as relative_opening_eval_20_last_ten_years_avg
    

from (
    select 
        ps.*,
        tg.year,
        tg.month, 
        tg.day,
        tg.eco,
        tg.result,
        DATE_DIFF(date, '2010-01-01', MONTH) month_pos,
        AVG(avg_diff) OVER (PARTITION BY player_id ORDER BY year, month, day rows between 1 preceding and 1 preceding) as avg_diff_last_3_games,
        AVG(avg_diff) OVER (PARTITION BY player_id ORDER BY year, month, day rows current row ) as avg_current,
        
    from `chessthesis`.`chess_thesis`.`stg_twicgames` tg 
    left join `chessthesis`.`chess_thesis`.`mrt_player_stats` ps on tg.id = ps.game_id 
    left join `chessthesis`.`chess_thesis`.`mrt_game_stats` gs on gs.game_id = tg.id
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

-- window funtions for eco code
, rolling_eco_three_months AS 
  (PARTITION BY eco ORDER BY month_pos RANGE BETWEEN 3 PRECEDING AND 1 PRECEDING )

, rolling_eco_six_months AS 
  (PARTITION BY eco ORDER BY month_pos RANGE BETWEEN 6 PRECEDING AND 1 PRECEDING )

, rolling_eco_twelve_months AS 
  (PARTITION BY eco ORDER BY month_pos RANGE BETWEEN 12 PRECEDING AND 1 PRECEDING )

, rolling_eco_two_years AS 
  (PARTITION BY eco ORDER BY month_pos RANGE BETWEEN 24 PRECEDING AND 1 PRECEDING )

, rolling_eco_four_years AS 
  (PARTITION BY eco ORDER BY month_pos RANGE BETWEEN 48 PRECEDING AND 1 PRECEDING )

, rolling_eco_ten_years AS 
  (PARTITION BY eco ORDER BY month_pos RANGE BETWEEN 120 PRECEDING AND 1 PRECEDING )