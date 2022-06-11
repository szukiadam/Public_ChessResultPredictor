


with twicgames as (
    select 
        id,
        white, 
        COALESCE(whiteelo,1400) as white_elo, 
        black,
        COALESCE(blackelo,1400) as black_elo, 
        COALESCE(whiteelo,1400) - COALESCE(blackelo,1400) as elo_diff,
        eco, 
        result,
        event,
        round,
        date,
        extract(year from date) as year,
        extract(month from date) as month,
        extract(day from date) as day,
        extract(dayofweek from date) as day_of_week,
        site,  
        whitetitle as white_title, 
        blacktitle as black_title, 
        moves, 
        whitefideid as white_fide_id, 
        blackfideid as black_fide_id,
        variation, 
        opening,
        variant,
        whiteteam as white_team,
        blackteam as black_team,
        eventtype, 
        fen, 
        setup, 
        is_fen_extracted

     from `chessthesis`.`chess_thesis`.`twicgames`
)

select *
from twicgames
--where white_fide_id = 751871
--or black_fide_id = 751871
--order by year, month asc