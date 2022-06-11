select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select *
from `chessthesis`.`chess_thesis`.`fide_players`
where fide_id is null



      
    ) dbt_internal_test