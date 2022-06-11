

  create or replace view `chessthesis`.`chess_thesis`.`mrt_opening_stats`
  OPTIONS()
  as select
    game_id,
    year, 
    month, 
    eco, 
    count(*) as total_games, 
    AVG(game_length) as avg_game_length,
    AVG(eval_10) as avg_eval_10,
    AVG(eval_15) as avg_eval_15,
    AVG(eval_20) as avg_eval_20

from `chessthesis`.`chess_thesis`.`mrt_game_stats`;

