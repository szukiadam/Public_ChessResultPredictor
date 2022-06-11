with static_game_stats as (
    select 
        game_id,
        max(fullmove_number) as game_length,
        max(CASE WHEN ply = 20 THEN evaluation END) as eval_10,
        max(CASE WHEN ply = 30 THEN evaluation END) as eval_15,
        max(CASE WHEN ply = 40 THEN evaluation END) as eval_20

    from 
        `chessthesis`.`chess_thesis`.`mrt_gamepositions_with_evaluations` 
    group by 
        game_id
)

-- store the columns from a_in and b_in as a list in jinja-- select every field, dynamically applying a rename to ensure there are no conflicts
select
    tg.*,
    sgs.*,
  
    ps_white.player_id as player_id_white,
    ps_black.player_id as player_id_black,
  
    ps_white.opponent_rating as opponent_rating_white,
    ps_black.opponent_rating as opponent_rating_black,
  
    ps_white.eco as eco_white,
    ps_black.eco as eco_black,
  
    ps_white.game_id as game_id_white,
    ps_black.game_id as game_id_black,
  
    ps_white.player_side as player_side_white,
    ps_black.player_side as player_side_black,
  
    ps_white.avg_diff as avg_diff_white,
    ps_black.avg_diff as avg_diff_black,
  
    ps_white.worst_move_diff as worst_move_diff_white,
    ps_black.worst_move_diff as worst_move_diff_black,
  
    ps_white.avg_eval_diff_midgame as avg_eval_diff_midgame_white,
    ps_black.avg_eval_diff_midgame as avg_eval_diff_midgame_black,
  
    ps_white.best_moves as best_moves_white,
    ps_black.best_moves as best_moves_black,
  
    ps_white.great_moves as great_moves_white,
    ps_black.great_moves as great_moves_black,
  
    ps_white.good_moves as good_moves_white,
    ps_black.good_moves as good_moves_black,
  
    ps_white.okay_moves as okay_moves_white,
    ps_black.okay_moves as okay_moves_black,
  
    ps_white.bad_moves as bad_moves_white,
    ps_black.bad_moves as bad_moves_black,
  
    ps_white.semi_blunders as semi_blunders_white,
    ps_black.semi_blunders as semi_blunders_black,
  
    ps_white.blunders as blunders_white,
    ps_black.blunders as blunders_black,
  
    ps_white.total_moves_post_20_ply as total_moves_post_20_ply_white,
    ps_black.total_moves_post_20_ply as total_moves_post_20_ply_black,
  
    ps_white.missed_blunders as missed_blunders_white,
    ps_black.missed_blunders as missed_blunders_black,
  
    ps_white.first_mistake_at_move as first_mistake_at_move_white,
    ps_black.first_mistake_at_move as first_mistake_at_move_black,
  
    ps_white.last_mistake_at_move as last_mistake_at_move_white,
    ps_black.last_mistake_at_move as last_mistake_at_move_black,
  
    ps_white.game_swing_win_to_draw as game_swing_win_to_draw_white,
    ps_black.game_swing_win_to_draw as game_swing_win_to_draw_black,
  
    ps_white.game_swing_win_to_lose as game_swing_win_to_lose_white,
    ps_black.game_swing_win_to_lose as game_swing_win_to_lose_black,
  
    ps_white.game_swing_draw_to_lose as game_swing_draw_to_lose_white,
    ps_black.game_swing_draw_to_lose as game_swing_draw_to_lose_black,
  
    ps_white.game_swing_early as game_swing_early_white,
    ps_black.game_swing_early as game_swing_early_black,
  
    ps_white.game_swing_earlymid as game_swing_earlymid_white,
    ps_black.game_swing_earlymid as game_swing_earlymid_black,
  
    ps_white.game_swing_mid as game_swing_mid_white,
    ps_black.game_swing_mid as game_swing_mid_black,
  
    ps_white.game_swing_midlate as game_swing_midlate_white,
    ps_black.game_swing_midlate as game_swing_midlate_black,
  
    ps_white.game_swing_late as game_swing_late_white,
    ps_black.game_swing_late as game_swing_late_black,
  
    ps_white.game_swing_superlate as game_swing_superlate_white,
    ps_black.game_swing_superlate as game_swing_superlate_black,
  
    ps_white.best_moves_ratio as best_moves_ratio_white,
    ps_black.best_moves_ratio as best_moves_ratio_black,
  
    ps_white.great_moves_ratio as great_moves_ratio_white,
    ps_black.great_moves_ratio as great_moves_ratio_black,
  
    ps_white.good_moves_ratio as good_moves_ratio_white,
    ps_black.good_moves_ratio as good_moves_ratio_black,
  
    ps_white.okay_moves_ratio as okay_moves_ratio_white,
    ps_black.okay_moves_ratio as okay_moves_ratio_black,
  
    ps_white.bad_moves_ratio as bad_moves_ratio_white,
    ps_black.bad_moves_ratio as bad_moves_ratio_black,
  
    ps_white.semi_blunders_ratio as semi_blunders_ratio_white,
    ps_black.semi_blunders_ratio as semi_blunders_ratio_black,
  
    ps_white.blunders_ratio as blunders_ratio_white,
    ps_black.blunders_ratio as blunders_ratio_black,
   
   
from `chessthesis`.`chess_thesis`.`mrt_filtered_twicgames` tg 
inner join static_game_stats sgs on tg.id = sgs.game_id
left join `chessthesis`.`chess_thesis`.`mrt_player_stats` ps_white on ps_white.game_id = tg.id and tg.white_fide_id = ps_white.player_id
left join `chessthesis`.`chess_thesis`.`mrt_player_stats` ps_black on ps_black.game_id = tg.id and tg.black_fide_id = ps_black.player_id
--where tg.white_fide_id = 751871
--or tg.black_fide_id = 751871