

  create or replace view `chessthesis`.`chess_thesis`.`mrt_opening_stats_for_game`
  OPTIONS()
  as with game_stats_with_month_pos as (
    select 
        CASE 
            WHEN white_elo >= 1000 AND white_elo < 1400 THEN '1000-1400' 
            WHEN white_elo >= 1400 AND white_elo < 1700 THEN '1400-1700' 
            WHEN white_elo >= 1700 AND white_elo < 2000 THEN '1700-2000' 
            WHEN white_elo >= 2000 AND white_elo < 2200 THEN '2000-2200' 
            WHEN white_elo >= 2200 AND white_elo < 2400 THEN '2200-2400' 
            WHEN white_elo >= 2400 AND white_elo < 2550 THEN '2400-2550' 
            WHEN white_elo >= 2550 AND white_elo < 2700 THEN '2550-2700' 
            WHEN white_elo >= 2700 THEN '2700-' 
            ELSE '0-1000'
        END as white_elo_group,

        CASE 
            WHEN black_elo >= 1000 AND black_elo < 1400 THEN '1000-1400' 
            WHEN black_elo >= 1400 AND black_elo < 1700 THEN '1400-1700' 
            WHEN black_elo >= 1700 AND black_elo < 2000 THEN '1700-2000' 
            WHEN black_elo >= 2000 AND black_elo < 2200 THEN '2000-2200' 
            WHEN black_elo >= 2200 AND black_elo < 2400 THEN '2200-2400' 
            WHEN black_elo >= 2400 AND black_elo < 2550 THEN '2400-2550' 
            WHEN black_elo >= 2550 AND black_elo < 2700 THEN '2550-2700' 
            WHEN black_elo >= 2700 THEN '2700-' 
            ELSE '0-1000'
        END as black_elo_group,

        *,
        DATE_DIFF(date, '2010-01-01', MONTH) month_pos
        
    from `chessthesis`.`chess_thesis`.`mrt_game_stats`
)

,

windowed_total_averages as (
    select 
        *,
        
        -- total averages in 10 year window
        -- LEAKAGE IS PRESENT HERE, BUT IS IT A PROBLEM??
        AVG(game_length) OVER() as game_length_avg,
        AVG(game_swing_early_white) OVER() as game_swing_early_white_avg,
        AVG(game_swing_early_black) OVER() as game_swing_early_black_avg,
        AVG(game_swing_earlymid_white) OVER() as game_swing_earlymid_white_avg,
        AVG(game_swing_earlymid_black) OVER() as game_swing_earlymid_black_avg,
        AVG(game_swing_mid_white) OVER() as game_swing_mid_white_avg,
        AVG(game_swing_mid_black) OVER() as game_swing_mid_black_avg,
        AVG(game_swing_midlate_white) OVER() as game_swing_midlate_white_avg,
        AVG(game_swing_midlate_black) OVER() as game_swing_midlate_black_avg,
        AVG(game_swing_late_white) OVER() as game_swing_late_white_avg,
        AVG(game_swing_late_black) OVER() as game_swing_late_black_avg,
        AVG(game_swing_superlate_white) OVER() as game_swing_superlate_white_avg,
        AVG(game_swing_superlate_black) OVER() as game_swing_superlate_black_avg,

        -- total games resulting in white win, draw or black win
        SUM(CASE WHEN result='1-0' THEN 1 ELSE 0 END) OVER() as total_white_win_count,
        SUM(CASE WHEN result='0-1' THEN 1 ELSE 0 END) OVER() as total_black_win_count,
        SUM(CASE WHEN result='1/2-1/2' THEN 1 ELSE 0 END) OVER() as total_draw_count,
        COUNT(*) OVER() as total_game_count


    from game_stats_with_month_pos
)

,


windowed_opening_stats as (

    select 
        *,

        -- eco averages without elo range
        -- use avg for all the games if value is null
        COALESCE(AVG(game_length) OVER (eco_10_years_window),NULL) as game_length_opening_avg,
        COALESCE(AVG(game_swing_early_white) OVER (eco_10_years_window), NULL) as game_swing_early_white_opening_avg,
        COALESCE(AVG(game_swing_early_black) OVER (eco_10_years_window), NULL)  as game_swing_early_black_opening_avg,
        COALESCE(AVG(game_swing_earlymid_white) OVER (eco_10_years_window), NULL)  as game_swing_earlymid_white_opening_avg,
        COALESCE(AVG(game_swing_earlymid_black) OVER (eco_10_years_window), NULL) as game_swing_earlymid_black_opening_avg,
        COALESCE(AVG(game_swing_mid_white) OVER (eco_10_years_window),NULL) as game_swing_mid_white_opening_avg,
        COALESCE(AVG(game_swing_mid_black) OVER (eco_10_years_window),NULL) as game_swing_mid_black_opening_avg,
        COALESCE(AVG(game_swing_midlate_white) OVER (eco_10_years_window),NULL) as game_swing_midlate_white_opening_avg,
        COALESCE(AVG(game_swing_midlate_black) OVER (eco_10_years_window),NULL) as game_swing_midlate_black_opening_avg,
        COALESCE(AVG(game_swing_late_white) OVER (eco_10_years_window),NULL) as game_swing_late_white_opening_avg,
        COALESCE(AVG(game_swing_late_black) OVER (eco_10_years_window),NULL) as game_swing_late_black_opening_avg,
        COALESCE(AVG(game_swing_superlate_white) OVER (eco_10_years_window),NULL) as game_swing_superlate_white_opening_avg,
        COALESCE(AVG(game_swing_superlate_black) OVER (eco_10_years_window),NULL) as game_swing_superlate_black_opening_avg,

        -- total games resulting in white win, draw or black win
        COALESCE(SUM(CASE WHEN result='1-0' THEN 1 ELSE 0 END) OVER (eco_10_years_window),NULL) as opening_white_win_count,
        COALESCE(SUM(CASE WHEN result='0-1' THEN 1 ELSE 0 END) OVER (eco_10_years_window),NULL) as opening_black_win_count,
        COALESCE(SUM(CASE WHEN result='1/2-1/2' THEN 1 ELSE 0 END) OVER (eco_10_years_window),NULL) as opening_draw_count,
        COALESCE(COUNT(*) OVER(eco_10_years_window), NULL) as opening_total_game_count

        from windowed_total_averages

    -- window funtion only for eco
    WINDOW eco_10_years_window as 
    (PARTITION BY eco ORDER BY month_pos RANGE BETWEEN 120 PRECEDING AND 1 PRECEDING )

)

,

windowed_opening_stats_in_elorange as (
    select 
        game_id,
        eco,
        white_elo_group,
        black_elo_group,
        opening_total_game_count,
        opening_white_win_count,
        opening_black_win_count,
        opening_draw_count,

        -- eco + elo_range averages
        -- in case the value is null, we use the value that doesn't care about elo ranges
        COALESCE(AVG(game_length) OVER (eco_elo_range_10_years_window), game_length_opening_avg) as game_length_opening_and_elo_avg,
        COALESCE(AVG(game_swing_early_white) OVER (eco_elo_range_10_years_window), game_swing_early_white_opening_avg) as game_swing_early_white_opening_and_elo_avg,
        COALESCE(AVG(game_swing_early_black) OVER (eco_elo_range_10_years_window), game_swing_early_black_opening_avg) as game_swing_early_black_opening_and_elo_avg,
        COALESCE(AVG(game_swing_earlymid_white) OVER (eco_elo_range_10_years_window), game_swing_earlymid_white_opening_avg) as game_swing_earlymid_white_opening_and_elo_avg,
        COALESCE(AVG(game_swing_earlymid_black) OVER (eco_elo_range_10_years_window), game_swing_earlymid_black_opening_avg) as game_swing_earlymid_black_opening_and_elo_avg,
        COALESCE(AVG(game_swing_mid_white) OVER (eco_elo_range_10_years_window), game_swing_mid_white_opening_avg) as game_swing_mid_white_opening_and_elo_avg,
        COALESCE(AVG(game_swing_mid_black) OVER (eco_elo_range_10_years_window), game_swing_mid_black_opening_avg) as game_swing_mid_black_opening_and_elo_avg,
        COALESCE(AVG(game_swing_midlate_white) OVER (eco_elo_range_10_years_window), game_swing_midlate_white_opening_avg) as game_swing_midlate_white_opening_and_elo_avg,
        COALESCE(AVG(game_swing_midlate_black) OVER (eco_elo_range_10_years_window), game_swing_midlate_black_opening_avg) as game_swing_midlate_black_opening_and_elo_avg,
        COALESCE(AVG(game_swing_late_white) OVER (eco_elo_range_10_years_window), game_swing_late_white_opening_avg) as game_swing_late_white_opening_and_elo_avg,
        COALESCE(AVG(game_swing_late_black) OVER (eco_elo_range_10_years_window), game_swing_late_black_opening_avg) as game_swing_late_black_opening_and_elo_avg,
        COALESCE(AVG(game_swing_superlate_white) OVER (eco_elo_range_10_years_window), game_swing_superlate_white_opening_avg) as game_swing_superlate_white_opening_and_elo_avg,
        COALESCE(AVG(game_swing_superlate_black) OVER (eco_elo_range_10_years_window), game_swing_superlate_black_opening_avg) as game_swing_superlate_black_opening_and_elo_avg,

        -- total games resulting in white win, draw or black win with respect to the elo ranges
        -- in case the value is null, we use the value that doesn't care about elo ranges
        COALESCE(SUM(CASE WHEN result='1-0' THEN 1 ELSE 0 END) OVER (eco_elo_range_10_years_window),opening_white_win_count) as opening_white_win_elorange_count,
        COALESCE(SUM(CASE WHEN result='0-1' THEN 1 ELSE 0 END) OVER (eco_elo_range_10_years_window),opening_black_win_count) as opening_black_win_elorange_count,
        COALESCE(SUM(CASE WHEN result='1/2-1/2' THEN 1 ELSE 0 END) OVER (eco_elo_range_10_years_window),opening_draw_count) as opening_draw_elorange_count,
        COALESCE(COUNT(*) OVER(eco_elo_range_10_years_window), opening_total_game_count) as opening_total_game_elorange_count

        -- TODO: the above statistics with respect to elo diff(0,50,100,150,200)

    from windowed_opening_stats
       
    -- window funtion for eco and elo range
    WINDOW eco_elo_range_10_years_window AS 
    (PARTITION BY eco, white_elo_group, black_elo_group ORDER BY month_pos RANGE BETWEEN 120 PRECEDING AND 1 PRECEDING )
)

select 
    *,
    COALESCE(NULLIF(opening_white_win_count,0) / 1.0*opening_total_game_count, 0) as opening_white_win_percentage,
    COALESCE(NULLIF(opening_black_win_count,0) / 1.0*opening_total_game_count ,0) as opening_black_win_percentage,
    COALESCE(NULLIF(opening_draw_count,0) / 1.0*opening_total_game_count ,0) as opening_draw_percentage,

    COALESCE(NULLIF(opening_white_win_elorange_count,0) / 1.0*opening_total_game_elorange_count,0) as opening_elorange_white_win_percentage,
    COALESCE(NULLIF(opening_black_win_elorange_count,0) / 1.0*opening_total_game_elorange_count,0) as opening_elorange_black_win_percentage,
    COALESCE(NULLIF(opening_draw_elorange_count,0) / 1.0*opening_total_game_elorange_count,0) as opening_elorange_draw_percentage

    --TODO: elo diff

from windowed_opening_stats_in_elorange;

