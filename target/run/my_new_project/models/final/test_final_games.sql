

  create or replace table `chessthesis`.`chess_thesis`.`test_final_games`
  
  
  OPTIONS()
  as (
    

select 
    COALESCE(white_elo, 1200) as white_elo, 
    COALESCE(black_elo, 1200) as black_elo, 
    eco, 
    EXTRACT(YEAR from tg.date) - fp1.birth_year as white_age,
    EXTRACT(YEAR from tg.date) - fp2.birth_year as black_age,
    result
from `chessthesis`.`chess_thesis`.`stg_twicgames` tg
left join `chessthesis`.`chess_thesis`.`stg_fide_players` fp1 on tg.white_fide_id = fp1.fide_id 
left join `chessthesis`.`chess_thesis`.`stg_fide_players` fp2 on tg.black_fide_id = fp2.fide_id
  );
  