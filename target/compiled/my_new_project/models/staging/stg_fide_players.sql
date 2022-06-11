

with fide_players as (
    select 
        fide_id,
        name as player_name,
        federation,
        gender, 
        title, 
        nullif(yob, 0) as birth_year
     from `chessthesis`.`chess_thesis`.`fide_players`
)

select *
from fide_players