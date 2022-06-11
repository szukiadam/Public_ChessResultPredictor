

  create or replace view `chessthesis`.`chess_thesis`.`mrt_twicgames_with_analysis`
  OPTIONS()
  as with analysis as (
    select * from `chessthesis`.`chess_thesis`.`stg_game_positions`
)

select * 
from analysis
limit 10;

