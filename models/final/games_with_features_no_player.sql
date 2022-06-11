{{
  config(
    materialized = "table",
    sort = "id",
    cluster_by = ["id"],
  )
}}

{%- set player_stat_cols = adapter.get_columns_in_relation(ref('mrt_player_stat_with_historical_for_game')) -%}
{%- set opening_stat_cols = adapter.get_columns_in_relation(ref('mrt_opening_stats_for_game')) -%}

with games_with_features_filtered_twicgames_features as (
  select 
    tg.id,
    tg.white_elo,
    tg.black_elo,
    tg.eco,
    tg.result, 
    tg.year,
    tg.month,
    tg.day,
    tg.day_of_week,
    tg.white_title,
    tg.black_title,
    tg.year - fp1.birth_year as white_age,  
    tg.year - fp2.birth_year as black_age,
    tg.elo_diff,
    --{% for col in player_stat_cols %}
    --    psfg1.{{col.name}} as {{col.name}}_white,
    --    psfg2.{{col.name}} as {{col.name}}_black,
    --{% endfor %}
    {% for col in opening_stat_cols %}
        sfg.{{col.name}} as {{col.name}}_opening,
    {% endfor %}
  from {{ ref('mrt_filtered_twicgames') }} tg 
  inner join {{ ref('mrt_player_stat_with_historical_for_game') }} psfg1 on psfg1.game_id = tg.id 
  and psfg1.player_id = tg.white_fide_id
  inner join {{ ref('mrt_player_stat_with_historical_for_game') }} psfg2 on psfg2.game_id = tg.id 
  and psfg2.player_id = tg.black_fide_id
  left join {{ ref('stg_fide_players') }} fp1 on tg.white_fide_id = fp1.fide_id
  left join {{ ref('stg_fide_players') }} fp2 on tg.black_fide_id = fp2.fide_id
  left join {{ ref('mrt_opening_stats_for_game') }} sfg on sfg.game_id = tg.id
)

, 

games_with_featured_filtered_complete as (
  select 
    * 
    except (game_id_opening, eco_opening)
  from games_with_features_filtered_twicgames_features
)

select * 
from games_with_featured_filtered_complete

