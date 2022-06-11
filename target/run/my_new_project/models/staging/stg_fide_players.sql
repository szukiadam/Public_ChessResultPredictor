

  create or replace table `chessthesis`.`chess_thesis`.`stg_fide_players`
  
  cluster by fide_id
  OPTIONS()
  as (
    

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
  );
  