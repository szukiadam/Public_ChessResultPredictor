{{
  config(
    materialized = "table",
    cluster_by = "fide_id",
  )
}}

with fide_players as (
    select 
        fide_id,
        name as player_name,
        federation,
        gender, 
        title, 
        nullif(yob, 0) as birth_year
     from {{ source('chess_thesis', 'fide_players') }}
)

select *
from fide_players

