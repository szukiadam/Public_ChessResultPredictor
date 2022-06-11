with games_with_features_filtered_twicgames_features as (
  select 
    tg.id,
    tg.white_elo,
    tg.black_elo,
    tg.eco,
    tg.result, 
    tg.year,
    tg.month,
    tg.day,
    tg.day_of_week,
    tg.white_title,
    tg.black_title,
    tg.year - fp1.birth_year as white_age,  
    tg.year - fp2.birth_year as black_age,
    tg.elo_diff,
    --
    --    psfg1.game_id as game_id_white,
    --    psfg2.game_id as game_id_black,
    --
    --    psfg1.player_id as player_id_white,
    --    psfg2.player_id as player_id_black,
    --
    --    psfg1.player_side as player_side_white,
    --    psfg2.player_side as player_side_black,
    --
    --    psfg1.opponent_rating as opponent_rating_white,
    --    psfg2.opponent_rating as opponent_rating_black,
    --
    --    psfg1.result as result_white,
    --    psfg2.result as result_black,
    --
    --    psfg1.games_played_last_three_months as games_played_last_three_months_white,
    --    psfg2.games_played_last_three_months as games_played_last_three_months_black,
    --
    --    psfg1.games_played_last_six_months as games_played_last_six_months_white,
    --    psfg2.games_played_last_six_months as games_played_last_six_months_black,
    --
    --    psfg1.games_played_last_twelve_months as games_played_last_twelve_months_white,
    --    psfg2.games_played_last_twelve_months as games_played_last_twelve_months_black,
    --
    --    psfg1.games_played_last_two_years as games_played_last_two_years_white,
    --    psfg2.games_played_last_two_years as games_played_last_two_years_black,
    --
    --    psfg1.games_played_last_four_years as games_played_last_four_years_white,
    --    psfg2.games_played_last_four_years as games_played_last_four_years_black,
    --
    --    psfg1.games_played_last_ten_years as games_played_last_ten_years_white,
    --    psfg2.games_played_last_ten_years as games_played_last_ten_years_black,
    --
    --    psfg1.opponent_rating_avg_last_three_months as opponent_rating_avg_last_three_months_white,
    --    psfg2.opponent_rating_avg_last_three_months as opponent_rating_avg_last_three_months_black,
    --
    --    psfg1.opponent_rating_avg_last_six_months as opponent_rating_avg_last_six_months_white,
    --    psfg2.opponent_rating_avg_last_six_months as opponent_rating_avg_last_six_months_black,
    --
    --    psfg1.opponent_rating_avg_last_twelve_months as opponent_rating_avg_last_twelve_months_white,
    --    psfg2.opponent_rating_avg_last_twelve_months as opponent_rating_avg_last_twelve_months_black,
    --
    --    psfg1.opponent_rating_avg_last_two_years as opponent_rating_avg_last_two_years_white,
    --    psfg2.opponent_rating_avg_last_two_years as opponent_rating_avg_last_two_years_black,
    --
    --    psfg1.opponent_rating_avg_last_four_years as opponent_rating_avg_last_four_years_white,
    --    psfg2.opponent_rating_avg_last_four_years as opponent_rating_avg_last_four_years_black,
    --
    --    psfg1.opponent_rating_avg_last_ten_years as opponent_rating_avg_last_ten_years_white,
    --    psfg2.opponent_rating_avg_last_ten_years as opponent_rating_avg_last_ten_years_black,
    --
    --    psfg1.opponent_rating_min_last_three_months as opponent_rating_min_last_three_months_white,
    --    psfg2.opponent_rating_min_last_three_months as opponent_rating_min_last_three_months_black,
    --
    --    psfg1.opponent_rating_min_last_six_months as opponent_rating_min_last_six_months_white,
    --    psfg2.opponent_rating_min_last_six_months as opponent_rating_min_last_six_months_black,
    --
    --    psfg1.opponent_rating_min_last_twelve_months as opponent_rating_min_last_twelve_months_white,
    --    psfg2.opponent_rating_min_last_twelve_months as opponent_rating_min_last_twelve_months_black,
    --
    --    psfg1.opponent_rating_min_last_two_years as opponent_rating_min_last_two_years_white,
    --    psfg2.opponent_rating_min_last_two_years as opponent_rating_min_last_two_years_black,
    --
    --    psfg1.opponent_rating_min_last_four_years as opponent_rating_min_last_four_years_white,
    --    psfg2.opponent_rating_min_last_four_years as opponent_rating_min_last_four_years_black,
    --
    --    psfg1.opponent_rating_min_last_ten_years as opponent_rating_min_last_ten_years_white,
    --    psfg2.opponent_rating_min_last_ten_years as opponent_rating_min_last_ten_years_black,
    --
    --    psfg1.opponent_rating_max_last_three_months as opponent_rating_max_last_three_months_white,
    --    psfg2.opponent_rating_max_last_three_months as opponent_rating_max_last_three_months_black,
    --
    --    psfg1.opponent_rating_max_last_six_months as opponent_rating_max_last_six_months_white,
    --    psfg2.opponent_rating_max_last_six_months as opponent_rating_max_last_six_months_black,
    --
    --    psfg1.opponent_rating_max_last_twelve_months as opponent_rating_max_last_twelve_months_white,
    --    psfg2.opponent_rating_max_last_twelve_months as opponent_rating_max_last_twelve_months_black,
    --
    --    psfg1.opponent_rating_max_last_two_years as opponent_rating_max_last_two_years_white,
    --    psfg2.opponent_rating_max_last_two_years as opponent_rating_max_last_two_years_black,
    --
    --    psfg1.opponent_rating_max_last_four_years as opponent_rating_max_last_four_years_white,
    --    psfg2.opponent_rating_max_last_four_years as opponent_rating_max_last_four_years_black,
    --
    --    psfg1.opponent_rating_max_last_ten_years as opponent_rating_max_last_ten_years_white,
    --    psfg2.opponent_rating_max_last_ten_years as opponent_rating_max_last_ten_years_black,
    --
    --    psfg1.rolling_three_months_performance as rolling_three_months_performance_white,
    --    psfg2.rolling_three_months_performance as rolling_three_months_performance_black,
    --
    --    psfg1.rolling_six_months_performance as rolling_six_months_performance_white,
    --    psfg2.rolling_six_months_performance as rolling_six_months_performance_black,
    --
    --    psfg1.rolling_twelve_months_performance as rolling_twelve_months_performance_white,
    --    psfg2.rolling_twelve_months_performance as rolling_twelve_months_performance_black,
    --
    --    psfg1.rolling_two_years_performance as rolling_two_years_performance_white,
    --    psfg2.rolling_two_years_performance as rolling_two_years_performance_black,
    --
    --    psfg1.rolling_four_years_performance as rolling_four_years_performance_white,
    --    psfg2.rolling_four_years_performance as rolling_four_years_performance_black,
    --
    --    psfg1.rolling_ten_years_performance as rolling_ten_years_performance_white,
    --    psfg2.rolling_ten_years_performance as rolling_ten_years_performance_black,
    --
    --    psfg1.avg_eval_diff_last_three_months as avg_eval_diff_last_three_months_white,
    --    psfg2.avg_eval_diff_last_three_months as avg_eval_diff_last_three_months_black,
    --
    --    psfg1.avg_eval_diff_last_six_months as avg_eval_diff_last_six_months_white,
    --    psfg2.avg_eval_diff_last_six_months as avg_eval_diff_last_six_months_black,
    --
    --    psfg1.avg_eval_diff_last_twelve_months as avg_eval_diff_last_twelve_months_white,
    --    psfg2.avg_eval_diff_last_twelve_months as avg_eval_diff_last_twelve_months_black,
    --
    --    psfg1.avg_eval_diff_last_two_years as avg_eval_diff_last_two_years_white,
    --    psfg2.avg_eval_diff_last_two_years as avg_eval_diff_last_two_years_black,
    --
    --    psfg1.avg_eval_diff_last_four_years as avg_eval_diff_last_four_years_white,
    --    psfg2.avg_eval_diff_last_four_years as avg_eval_diff_last_four_years_black,
    --
    --    psfg1.avg_eval_diff_last_ten_years as avg_eval_diff_last_ten_years_white,
    --    psfg2.avg_eval_diff_last_ten_years as avg_eval_diff_last_ten_years_black,
    --
    --    psfg1.best_moves_ratio_last_three_months as best_moves_ratio_last_three_months_white,
    --    psfg2.best_moves_ratio_last_three_months as best_moves_ratio_last_three_months_black,
    --
    --    psfg1.best_moves_ratio_last_six_months as best_moves_ratio_last_six_months_white,
    --    psfg2.best_moves_ratio_last_six_months as best_moves_ratio_last_six_months_black,
    --
    --    psfg1.best_moves_ratio_last_twelve_months as best_moves_ratio_last_twelve_months_white,
    --    psfg2.best_moves_ratio_last_twelve_months as best_moves_ratio_last_twelve_months_black,
    --
    --    psfg1.best_moves_ratio_last_two_years as best_moves_ratio_last_two_years_white,
    --    psfg2.best_moves_ratio_last_two_years as best_moves_ratio_last_two_years_black,
    --
    --    psfg1.best_moves_ratio_last_four_years as best_moves_ratio_last_four_years_white,
    --    psfg2.best_moves_ratio_last_four_years as best_moves_ratio_last_four_years_black,
    --
    --    psfg1.best_moves_ratio_last_ten_years as best_moves_ratio_last_ten_years_white,
    --    psfg2.best_moves_ratio_last_ten_years as best_moves_ratio_last_ten_years_black,
    --
    --    psfg1.great_moves_ratio_last_three_months as great_moves_ratio_last_three_months_white,
    --    psfg2.great_moves_ratio_last_three_months as great_moves_ratio_last_three_months_black,
    --
    --    psfg1.great_moves_ratio_last_six_months as great_moves_ratio_last_six_months_white,
    --    psfg2.great_moves_ratio_last_six_months as great_moves_ratio_last_six_months_black,
    --
    --    psfg1.great_moves_ratio_last_twelve_months as great_moves_ratio_last_twelve_months_white,
    --    psfg2.great_moves_ratio_last_twelve_months as great_moves_ratio_last_twelve_months_black,
    --
    --    psfg1.great_moves_ratio_last_two_years as great_moves_ratio_last_two_years_white,
    --    psfg2.great_moves_ratio_last_two_years as great_moves_ratio_last_two_years_black,
    --
    --    psfg1.great_moves_ratio_last_four_years as great_moves_ratio_last_four_years_white,
    --    psfg2.great_moves_ratio_last_four_years as great_moves_ratio_last_four_years_black,
    --
    --    psfg1.great_moves_ratio_last_ten_years as great_moves_ratio_last_ten_years_white,
    --    psfg2.great_moves_ratio_last_ten_years as great_moves_ratio_last_ten_years_black,
    --
    --    psfg1.good_moves_ratio_last_three_months as good_moves_ratio_last_three_months_white,
    --    psfg2.good_moves_ratio_last_three_months as good_moves_ratio_last_three_months_black,
    --
    --    psfg1.good_moves_ratio_last_six_months as good_moves_ratio_last_six_months_white,
    --    psfg2.good_moves_ratio_last_six_months as good_moves_ratio_last_six_months_black,
    --
    --    psfg1.good_moves_ratio_last_twelve_months as good_moves_ratio_last_twelve_months_white,
    --    psfg2.good_moves_ratio_last_twelve_months as good_moves_ratio_last_twelve_months_black,
    --
    --    psfg1.good_moves_ratio_last_two_years as good_moves_ratio_last_two_years_white,
    --    psfg2.good_moves_ratio_last_two_years as good_moves_ratio_last_two_years_black,
    --
    --    psfg1.good_moves_ratio_last_four_years as good_moves_ratio_last_four_years_white,
    --    psfg2.good_moves_ratio_last_four_years as good_moves_ratio_last_four_years_black,
    --
    --    psfg1.good_moves_ratio_last_ten_years as good_moves_ratio_last_ten_years_white,
    --    psfg2.good_moves_ratio_last_ten_years as good_moves_ratio_last_ten_years_black,
    --
    --    psfg1.okay_moves_ratio_last_three_months as okay_moves_ratio_last_three_months_white,
    --    psfg2.okay_moves_ratio_last_three_months as okay_moves_ratio_last_three_months_black,
    --
    --    psfg1.okay_moves_ratio_last_six_months as okay_moves_ratio_last_six_months_white,
    --    psfg2.okay_moves_ratio_last_six_months as okay_moves_ratio_last_six_months_black,
    --
    --    psfg1.okay_moves_ratio_last_twelve_months as okay_moves_ratio_last_twelve_months_white,
    --    psfg2.okay_moves_ratio_last_twelve_months as okay_moves_ratio_last_twelve_months_black,
    --
    --    psfg1.okay_moves_ratio_last_two_years as okay_moves_ratio_last_two_years_white,
    --    psfg2.okay_moves_ratio_last_two_years as okay_moves_ratio_last_two_years_black,
    --
    --    psfg1.okay_moves_ratio_last_four_years as okay_moves_ratio_last_four_years_white,
    --    psfg2.okay_moves_ratio_last_four_years as okay_moves_ratio_last_four_years_black,
    --
    --    psfg1.okay_moves_ratio_last_ten_years as okay_moves_ratio_last_ten_years_white,
    --    psfg2.okay_moves_ratio_last_ten_years as okay_moves_ratio_last_ten_years_black,
    --
    --    psfg1.bad_moves_ratio_last_three_months as bad_moves_ratio_last_three_months_white,
    --    psfg2.bad_moves_ratio_last_three_months as bad_moves_ratio_last_three_months_black,
    --
    --    psfg1.bad_moves_ratio_last_six_months as bad_moves_ratio_last_six_months_white,
    --    psfg2.bad_moves_ratio_last_six_months as bad_moves_ratio_last_six_months_black,
    --
    --    psfg1.bad_moves_ratio_last_twelve_months as bad_moves_ratio_last_twelve_months_white,
    --    psfg2.bad_moves_ratio_last_twelve_months as bad_moves_ratio_last_twelve_months_black,
    --
    --    psfg1.bad_moves_ratio_last_two_years as bad_moves_ratio_last_two_years_white,
    --    psfg2.bad_moves_ratio_last_two_years as bad_moves_ratio_last_two_years_black,
    --
    --    psfg1.bad_moves_ratio_last_four_years as bad_moves_ratio_last_four_years_white,
    --    psfg2.bad_moves_ratio_last_four_years as bad_moves_ratio_last_four_years_black,
    --
    --    psfg1.bad_moves_ratio_last_ten_years as bad_moves_ratio_last_ten_years_white,
    --    psfg2.bad_moves_ratio_last_ten_years as bad_moves_ratio_last_ten_years_black,
    --
    --    psfg1.semi_blunders_ratio_last_three_months as semi_blunders_ratio_last_three_months_white,
    --    psfg2.semi_blunders_ratio_last_three_months as semi_blunders_ratio_last_three_months_black,
    --
    --    psfg1.semi_blunders_ratio_last_six_months as semi_blunders_ratio_last_six_months_white,
    --    psfg2.semi_blunders_ratio_last_six_months as semi_blunders_ratio_last_six_months_black,
    --
    --    psfg1.semi_blunders_ratio_last_twelve_months as semi_blunders_ratio_last_twelve_months_white,
    --    psfg2.semi_blunders_ratio_last_twelve_months as semi_blunders_ratio_last_twelve_months_black,
    --
    --    psfg1.semi_blunders_ratio_last_two_years as semi_blunders_ratio_last_two_years_white,
    --    psfg2.semi_blunders_ratio_last_two_years as semi_blunders_ratio_last_two_years_black,
    --
    --    psfg1.semi_blunders_ratio_last_four_years as semi_blunders_ratio_last_four_years_white,
    --    psfg2.semi_blunders_ratio_last_four_years as semi_blunders_ratio_last_four_years_black,
    --
    --    psfg1.semi_blunders_ratio_last_ten_years as semi_blunders_ratio_last_ten_years_white,
    --    psfg2.semi_blunders_ratio_last_ten_years as semi_blunders_ratio_last_ten_years_black,
    --
    --    psfg1.blunders_ratio_last_three_months as blunders_ratio_last_three_months_white,
    --    psfg2.blunders_ratio_last_three_months as blunders_ratio_last_three_months_black,
    --
    --    psfg1.blunders_ratio_last_six_months as blunders_ratio_last_six_months_white,
    --    psfg2.blunders_ratio_last_six_months as blunders_ratio_last_six_months_black,
    --
    --    psfg1.blunders_ratio_last_twelve_months as blunders_ratio_last_twelve_months_white,
    --    psfg2.blunders_ratio_last_twelve_months as blunders_ratio_last_twelve_months_black,
    --
    --    psfg1.blunders_ratio_last_two_years as blunders_ratio_last_two_years_white,
    --    psfg2.blunders_ratio_last_two_years as blunders_ratio_last_two_years_black,
    --
    --    psfg1.blunders_ratio_last_four_years as blunders_ratio_last_four_years_white,
    --    psfg2.blunders_ratio_last_four_years as blunders_ratio_last_four_years_black,
    --
    --    psfg1.blunders_ratio_last_ten_years as blunders_ratio_last_ten_years_white,
    --    psfg2.blunders_ratio_last_ten_years as blunders_ratio_last_ten_years_black,
    --
    --    psfg1.game_length_avg_last_three_months as game_length_avg_last_three_months_white,
    --    psfg2.game_length_avg_last_three_months as game_length_avg_last_three_months_black,
    --
    --    psfg1.game_length_avg_last_six_months as game_length_avg_last_six_months_white,
    --    psfg2.game_length_avg_last_six_months as game_length_avg_last_six_months_black,
    --
    --    psfg1.game_length_avg_last_twelve_months as game_length_avg_last_twelve_months_white,
    --    psfg2.game_length_avg_last_twelve_months as game_length_avg_last_twelve_months_black,
    --
    --    psfg1.game_length_avg_last_two_years as game_length_avg_last_two_years_white,
    --    psfg2.game_length_avg_last_two_years as game_length_avg_last_two_years_black,
    --
    --    psfg1.game_length_avg_last_four_years as game_length_avg_last_four_years_white,
    --    psfg2.game_length_avg_last_four_years as game_length_avg_last_four_years_black,
    --
    --    psfg1.game_length_avg_last_ten_years as game_length_avg_last_ten_years_white,
    --    psfg2.game_length_avg_last_ten_years as game_length_avg_last_ten_years_black,
    --
    --    psfg1.game_length_min_last_three_months as game_length_min_last_three_months_white,
    --    psfg2.game_length_min_last_three_months as game_length_min_last_three_months_black,
    --
    --    psfg1.game_length_min_last_six_months as game_length_min_last_six_months_white,
    --    psfg2.game_length_min_last_six_months as game_length_min_last_six_months_black,
    --
    --    psfg1.game_length_min_last_twelve_months as game_length_min_last_twelve_months_white,
    --    psfg2.game_length_min_last_twelve_months as game_length_min_last_twelve_months_black,
    --
    --    psfg1.game_length_min_last_two_years as game_length_min_last_two_years_white,
    --    psfg2.game_length_min_last_two_years as game_length_min_last_two_years_black,
    --
    --    psfg1.game_length_min_last_four_years as game_length_min_last_four_years_white,
    --    psfg2.game_length_min_last_four_years as game_length_min_last_four_years_black,
    --
    --    psfg1.game_length_min_last_ten_years as game_length_min_last_ten_years_white,
    --    psfg2.game_length_min_last_ten_years as game_length_min_last_ten_years_black,
    --
    --    psfg1.relative_opening_eval_10_last_three_months_min as relative_opening_eval_10_last_three_months_min_white,
    --    psfg2.relative_opening_eval_10_last_three_months_min as relative_opening_eval_10_last_three_months_min_black,
    --
    --    psfg1.relative_opening_eval_10_last_six_months_min as relative_opening_eval_10_last_six_months_min_white,
    --    psfg2.relative_opening_eval_10_last_six_months_min as relative_opening_eval_10_last_six_months_min_black,
    --
    --    psfg1.relative_opening_eval_10_last_twelve_months_min as relative_opening_eval_10_last_twelve_months_min_white,
    --    psfg2.relative_opening_eval_10_last_twelve_months_min as relative_opening_eval_10_last_twelve_months_min_black,
    --
    --    psfg1.relative_opening_eval_10_last_two_years_min as relative_opening_eval_10_last_two_years_min_white,
    --    psfg2.relative_opening_eval_10_last_two_years_min as relative_opening_eval_10_last_two_years_min_black,
    --
    --    psfg1.relative_opening_eval_10_last_four_years_min as relative_opening_eval_10_last_four_years_min_white,
    --    psfg2.relative_opening_eval_10_last_four_years_min as relative_opening_eval_10_last_four_years_min_black,
    --
    --    psfg1.relative_opening_eval_10_last_ten_years_min as relative_opening_eval_10_last_ten_years_min_white,
    --    psfg2.relative_opening_eval_10_last_ten_years_min as relative_opening_eval_10_last_ten_years_min_black,
    --
    --    psfg1.relative_opening_eval_10_last_three_months_max as relative_opening_eval_10_last_three_months_max_white,
    --    psfg2.relative_opening_eval_10_last_three_months_max as relative_opening_eval_10_last_three_months_max_black,
    --
    --    psfg1.relative_opening_eval_10_last_six_months_max as relative_opening_eval_10_last_six_months_max_white,
    --    psfg2.relative_opening_eval_10_last_six_months_max as relative_opening_eval_10_last_six_months_max_black,
    --
    --    psfg1.relative_opening_eval_10_last_twelve_months_max as relative_opening_eval_10_last_twelve_months_max_white,
    --    psfg2.relative_opening_eval_10_last_twelve_months_max as relative_opening_eval_10_last_twelve_months_max_black,
    --
    --    psfg1.relative_opening_eval_10_last_two_years_max as relative_opening_eval_10_last_two_years_max_white,
    --    psfg2.relative_opening_eval_10_last_two_years_max as relative_opening_eval_10_last_two_years_max_black,
    --
    --    psfg1.relative_opening_eval_10_last_four_years_max as relative_opening_eval_10_last_four_years_max_white,
    --    psfg2.relative_opening_eval_10_last_four_years_max as relative_opening_eval_10_last_four_years_max_black,
    --
    --    psfg1.relative_opening_eval_10_last_ten_years_max as relative_opening_eval_10_last_ten_years_max_white,
    --    psfg2.relative_opening_eval_10_last_ten_years_max as relative_opening_eval_10_last_ten_years_max_black,
    --
    --    psfg1.relative_opening_eval_10_last_three_months_avg as relative_opening_eval_10_last_three_months_avg_white,
    --    psfg2.relative_opening_eval_10_last_three_months_avg as relative_opening_eval_10_last_three_months_avg_black,
    --
    --    psfg1.relative_opening_eval_10_last_six_months_avg as relative_opening_eval_10_last_six_months_avg_white,
    --    psfg2.relative_opening_eval_10_last_six_months_avg as relative_opening_eval_10_last_six_months_avg_black,
    --
    --    psfg1.relative_opening_eval_10_last_twelve_months_avg as relative_opening_eval_10_last_twelve_months_avg_white,
    --    psfg2.relative_opening_eval_10_last_twelve_months_avg as relative_opening_eval_10_last_twelve_months_avg_black,
    --
    --    psfg1.relative_opening_eval_10_last_two_years_avg as relative_opening_eval_10_last_two_years_avg_white,
    --    psfg2.relative_opening_eval_10_last_two_years_avg as relative_opening_eval_10_last_two_years_avg_black,
    --
    --    psfg1.relative_opening_eval_10_last_four_years_avg as relative_opening_eval_10_last_four_years_avg_white,
    --    psfg2.relative_opening_eval_10_last_four_years_avg as relative_opening_eval_10_last_four_years_avg_black,
    --
    --    psfg1.relative_opening_eval_10_last_ten_years_avg as relative_opening_eval_10_last_ten_years_avg_white,
    --    psfg2.relative_opening_eval_10_last_ten_years_avg as relative_opening_eval_10_last_ten_years_avg_black,
    --
    --    psfg1.relative_opening_eval_15_last_three_months_min as relative_opening_eval_15_last_three_months_min_white,
    --    psfg2.relative_opening_eval_15_last_three_months_min as relative_opening_eval_15_last_three_months_min_black,
    --
    --    psfg1.relative_opening_eval_15_last_six_months_min as relative_opening_eval_15_last_six_months_min_white,
    --    psfg2.relative_opening_eval_15_last_six_months_min as relative_opening_eval_15_last_six_months_min_black,
    --
    --    psfg1.relative_opening_eval_15_last_twelve_months_min as relative_opening_eval_15_last_twelve_months_min_white,
    --    psfg2.relative_opening_eval_15_last_twelve_months_min as relative_opening_eval_15_last_twelve_months_min_black,
    --
    --    psfg1.relative_opening_eval_15_last_two_years_min as relative_opening_eval_15_last_two_years_min_white,
    --    psfg2.relative_opening_eval_15_last_two_years_min as relative_opening_eval_15_last_two_years_min_black,
    --
    --    psfg1.relative_opening_eval_15_last_four_years_min as relative_opening_eval_15_last_four_years_min_white,
    --    psfg2.relative_opening_eval_15_last_four_years_min as relative_opening_eval_15_last_four_years_min_black,
    --
    --    psfg1.relative_opening_eval_15_last_ten_years_min as relative_opening_eval_15_last_ten_years_min_white,
    --    psfg2.relative_opening_eval_15_last_ten_years_min as relative_opening_eval_15_last_ten_years_min_black,
    --
    --    psfg1.relative_opening_eval_15_last_three_months_max as relative_opening_eval_15_last_three_months_max_white,
    --    psfg2.relative_opening_eval_15_last_three_months_max as relative_opening_eval_15_last_three_months_max_black,
    --
    --    psfg1.relative_opening_eval_15_last_six_months_max as relative_opening_eval_15_last_six_months_max_white,
    --    psfg2.relative_opening_eval_15_last_six_months_max as relative_opening_eval_15_last_six_months_max_black,
    --
    --    psfg1.relative_opening_eval_15_last_twelve_months_max as relative_opening_eval_15_last_twelve_months_max_white,
    --    psfg2.relative_opening_eval_15_last_twelve_months_max as relative_opening_eval_15_last_twelve_months_max_black,
    --
    --    psfg1.relative_opening_eval_15_last_two_years_max as relative_opening_eval_15_last_two_years_max_white,
    --    psfg2.relative_opening_eval_15_last_two_years_max as relative_opening_eval_15_last_two_years_max_black,
    --
    --    psfg1.relative_opening_eval_15_last_four_years_max as relative_opening_eval_15_last_four_years_max_white,
    --    psfg2.relative_opening_eval_15_last_four_years_max as relative_opening_eval_15_last_four_years_max_black,
    --
    --    psfg1.relative_opening_eval_15_last_ten_years_max as relative_opening_eval_15_last_ten_years_max_white,
    --    psfg2.relative_opening_eval_15_last_ten_years_max as relative_opening_eval_15_last_ten_years_max_black,
    --
    --    psfg1.relative_opening_eval_15_last_three_months_avg as relative_opening_eval_15_last_three_months_avg_white,
    --    psfg2.relative_opening_eval_15_last_three_months_avg as relative_opening_eval_15_last_three_months_avg_black,
    --
    --    psfg1.relative_opening_eval_15_last_six_months_avg as relative_opening_eval_15_last_six_months_avg_white,
    --    psfg2.relative_opening_eval_15_last_six_months_avg as relative_opening_eval_15_last_six_months_avg_black,
    --
    --    psfg1.relative_opening_eval_15_last_twelve_months_avg as relative_opening_eval_15_last_twelve_months_avg_white,
    --    psfg2.relative_opening_eval_15_last_twelve_months_avg as relative_opening_eval_15_last_twelve_months_avg_black,
    --
    --    psfg1.relative_opening_eval_15_last_two_years_avg as relative_opening_eval_15_last_two_years_avg_white,
    --    psfg2.relative_opening_eval_15_last_two_years_avg as relative_opening_eval_15_last_two_years_avg_black,
    --
    --    psfg1.relative_opening_eval_15_last_four_years_avg as relative_opening_eval_15_last_four_years_avg_white,
    --    psfg2.relative_opening_eval_15_last_four_years_avg as relative_opening_eval_15_last_four_years_avg_black,
    --
    --    psfg1.relative_opening_eval_15_last_ten_years_avg as relative_opening_eval_15_last_ten_years_avg_white,
    --    psfg2.relative_opening_eval_15_last_ten_years_avg as relative_opening_eval_15_last_ten_years_avg_black,
    --
    --    psfg1.relative_opening_eval_20_last_three_months_min as relative_opening_eval_20_last_three_months_min_white,
    --    psfg2.relative_opening_eval_20_last_three_months_min as relative_opening_eval_20_last_three_months_min_black,
    --
    --    psfg1.relative_opening_eval_20_last_six_months_min as relative_opening_eval_20_last_six_months_min_white,
    --    psfg2.relative_opening_eval_20_last_six_months_min as relative_opening_eval_20_last_six_months_min_black,
    --
    --    psfg1.relative_opening_eval_20_last_twelve_months_min as relative_opening_eval_20_last_twelve_months_min_white,
    --    psfg2.relative_opening_eval_20_last_twelve_months_min as relative_opening_eval_20_last_twelve_months_min_black,
    --
    --    psfg1.relative_opening_eval_20_last_two_years_min as relative_opening_eval_20_last_two_years_min_white,
    --    psfg2.relative_opening_eval_20_last_two_years_min as relative_opening_eval_20_last_two_years_min_black,
    --
    --    psfg1.relative_opening_eval_20_last_four_years_min as relative_opening_eval_20_last_four_years_min_white,
    --    psfg2.relative_opening_eval_20_last_four_years_min as relative_opening_eval_20_last_four_years_min_black,
    --
    --    psfg1.relative_opening_eval_20_last_ten_years_min as relative_opening_eval_20_last_ten_years_min_white,
    --    psfg2.relative_opening_eval_20_last_ten_years_min as relative_opening_eval_20_last_ten_years_min_black,
    --
    --    psfg1.relative_opening_eval_20_last_three_months_max as relative_opening_eval_20_last_three_months_max_white,
    --    psfg2.relative_opening_eval_20_last_three_months_max as relative_opening_eval_20_last_three_months_max_black,
    --
    --    psfg1.relative_opening_eval_20_last_six_months_max as relative_opening_eval_20_last_six_months_max_white,
    --    psfg2.relative_opening_eval_20_last_six_months_max as relative_opening_eval_20_last_six_months_max_black,
    --
    --    psfg1.relative_opening_eval_20_last_twelve_months_max as relative_opening_eval_20_last_twelve_months_max_white,
    --    psfg2.relative_opening_eval_20_last_twelve_months_max as relative_opening_eval_20_last_twelve_months_max_black,
    --
    --    psfg1.relative_opening_eval_20_last_two_years_max as relative_opening_eval_20_last_two_years_max_white,
    --    psfg2.relative_opening_eval_20_last_two_years_max as relative_opening_eval_20_last_two_years_max_black,
    --
    --    psfg1.relative_opening_eval_20_last_four_years_max as relative_opening_eval_20_last_four_years_max_white,
    --    psfg2.relative_opening_eval_20_last_four_years_max as relative_opening_eval_20_last_four_years_max_black,
    --
    --    psfg1.relative_opening_eval_20_last_ten_years_max as relative_opening_eval_20_last_ten_years_max_white,
    --    psfg2.relative_opening_eval_20_last_ten_years_max as relative_opening_eval_20_last_ten_years_max_black,
    --
    --    psfg1.relative_opening_eval_20_last_three_months_avg as relative_opening_eval_20_last_three_months_avg_white,
    --    psfg2.relative_opening_eval_20_last_three_months_avg as relative_opening_eval_20_last_three_months_avg_black,
    --
    --    psfg1.relative_opening_eval_20_last_six_months_avg as relative_opening_eval_20_last_six_months_avg_white,
    --    psfg2.relative_opening_eval_20_last_six_months_avg as relative_opening_eval_20_last_six_months_avg_black,
    --
    --    psfg1.relative_opening_eval_20_last_twelve_months_avg as relative_opening_eval_20_last_twelve_months_avg_white,
    --    psfg2.relative_opening_eval_20_last_twelve_months_avg as relative_opening_eval_20_last_twelve_months_avg_black,
    --
    --    psfg1.relative_opening_eval_20_last_two_years_avg as relative_opening_eval_20_last_two_years_avg_white,
    --    psfg2.relative_opening_eval_20_last_two_years_avg as relative_opening_eval_20_last_two_years_avg_black,
    --
    --    psfg1.relative_opening_eval_20_last_four_years_avg as relative_opening_eval_20_last_four_years_avg_white,
    --    psfg2.relative_opening_eval_20_last_four_years_avg as relative_opening_eval_20_last_four_years_avg_black,
    --
    --    psfg1.relative_opening_eval_20_last_ten_years_avg as relative_opening_eval_20_last_ten_years_avg_white,
    --    psfg2.relative_opening_eval_20_last_ten_years_avg as relative_opening_eval_20_last_ten_years_avg_black,
    --
    
        sfg.game_id as game_id_opening,
    
        sfg.eco as eco_opening,
    
        sfg.white_elo_group as white_elo_group_opening,
    
        sfg.black_elo_group as black_elo_group_opening,
    
        sfg.opening_total_game_count as opening_total_game_count_opening,
    
        sfg.opening_white_win_count as opening_white_win_count_opening,
    
        sfg.opening_black_win_count as opening_black_win_count_opening,
    
        sfg.opening_draw_count as opening_draw_count_opening,
    
        sfg.game_length_opening_and_elo_avg as game_length_opening_and_elo_avg_opening,
    
        sfg.game_swing_early_white_opening_and_elo_avg as game_swing_early_white_opening_and_elo_avg_opening,
    
        sfg.game_swing_early_black_opening_and_elo_avg as game_swing_early_black_opening_and_elo_avg_opening,
    
        sfg.game_swing_earlymid_white_opening_and_elo_avg as game_swing_earlymid_white_opening_and_elo_avg_opening,
    
        sfg.game_swing_earlymid_black_opening_and_elo_avg as game_swing_earlymid_black_opening_and_elo_avg_opening,
    
        sfg.game_swing_mid_white_opening_and_elo_avg as game_swing_mid_white_opening_and_elo_avg_opening,
    
        sfg.game_swing_mid_black_opening_and_elo_avg as game_swing_mid_black_opening_and_elo_avg_opening,
    
        sfg.game_swing_midlate_white_opening_and_elo_avg as game_swing_midlate_white_opening_and_elo_avg_opening,
    
        sfg.game_swing_midlate_black_opening_and_elo_avg as game_swing_midlate_black_opening_and_elo_avg_opening,
    
        sfg.game_swing_late_white_opening_and_elo_avg as game_swing_late_white_opening_and_elo_avg_opening,
    
        sfg.game_swing_late_black_opening_and_elo_avg as game_swing_late_black_opening_and_elo_avg_opening,
    
        sfg.game_swing_superlate_white_opening_and_elo_avg as game_swing_superlate_white_opening_and_elo_avg_opening,
    
        sfg.game_swing_superlate_black_opening_and_elo_avg as game_swing_superlate_black_opening_and_elo_avg_opening,
    
        sfg.opening_white_win_elorange_count as opening_white_win_elorange_count_opening,
    
        sfg.opening_black_win_elorange_count as opening_black_win_elorange_count_opening,
    
        sfg.opening_draw_elorange_count as opening_draw_elorange_count_opening,
    
        sfg.opening_total_game_elorange_count as opening_total_game_elorange_count_opening,
    
        sfg.opening_white_win_percentage as opening_white_win_percentage_opening,
    
        sfg.opening_black_win_percentage as opening_black_win_percentage_opening,
    
        sfg.opening_draw_percentage as opening_draw_percentage_opening,
    
        sfg.opening_elorange_white_win_percentage as opening_elorange_white_win_percentage_opening,
    
        sfg.opening_elorange_black_win_percentage as opening_elorange_black_win_percentage_opening,
    
        sfg.opening_elorange_draw_percentage as opening_elorange_draw_percentage_opening,
    
  from `chessthesis`.`chess_thesis`.`mrt_filtered_twicgames` tg 
  inner join `chessthesis`.`chess_thesis`.`mrt_player_stat_with_historical_for_game` psfg1 on psfg1.game_id = tg.id 
  and psfg1.player_id = tg.white_fide_id
  inner join `chessthesis`.`chess_thesis`.`mrt_player_stat_with_historical_for_game` psfg2 on psfg2.game_id = tg.id 
  and psfg2.player_id = tg.black_fide_id
  left join `chessthesis`.`chess_thesis`.`stg_fide_players` fp1 on tg.white_fide_id = fp1.fide_id
  left join `chessthesis`.`chess_thesis`.`stg_fide_players` fp2 on tg.black_fide_id = fp2.fide_id
  left join `chessthesis`.`chess_thesis`.`mrt_opening_stats_for_game` sfg on sfg.game_id = tg.id
)

, 

games_with_featured_filtered_complete as (
  select 
    * 
    except (game_id_opening, eco_opening)
  from games_with_features_filtered_twicgames_features
)

select * 
from games_with_featured_filtered_complete