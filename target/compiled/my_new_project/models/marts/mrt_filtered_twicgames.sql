

-- TWICGAMES but filtered
-- We will drop rows where
-- the moves field is empty or null
-- the event contains the 'rapid' or 'blitz' word

with fix_balogh_csaba as (
  select 
    * except (white_elo, black_elo),
    CASE WHEN white_fide_id = 790877 THEN 2586 ELSE white_elo END as white_elo,
    CASE WHEN black_fide_id = 790877 THEN 2586 ELSE black_elo END as black_elo,
  from `chessthesis`.`chess_thesis`.`stg_twicgames` 
)

select *
from fix_balogh_csaba
where moves != ''
and moves is not null
and UPPER(event) NOT LIKE '%RAPID%'
and UPPER(event) NOT LIKE '%BLITZ%'