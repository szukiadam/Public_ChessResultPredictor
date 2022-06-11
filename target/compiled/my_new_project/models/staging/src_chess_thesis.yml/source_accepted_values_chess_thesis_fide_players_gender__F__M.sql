
    
    

with all_values as (

    select
        gender as value_field,
        count(*) as n_records

    from `chessthesis`.`chess_thesis`.`fide_players`
    group by gender

)

select *
from all_values
where value_field not in (
    'F','M'
)


