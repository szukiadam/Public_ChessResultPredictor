with analysis as (
    select * from `chessthesis`.`chess_thesis`.`stg_game_positions`
)

select * 
from analysis
limit 10