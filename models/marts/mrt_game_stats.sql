with static_game_stats as (
    select 
        game_id,
        max(fullmove_number) as game_length,
        max(CASE WHEN ply = 20 THEN evaluation END) as eval_10,
        max(CASE WHEN ply = 30 THEN evaluation END) as eval_15,
        max(CASE WHEN ply = 40 THEN evaluation END) as eval_20

    from 
        {{ ref('mrt_gamepositions_with_evaluations') }} 
    group by 
        game_id
)

-- store the columns from a_in and b_in as a list in jinja
{%- set common_cols = adapter.get_columns_in_relation(ref('mrt_player_stats')) -%}

-- select every field, dynamically applying a rename to ensure there are no conflicts
select
    tg.*,
    sgs.*,
  {% for col in common_cols %}
    ps_white.{{col.name}} as {{col.name}}_white,
    ps_black.{{col.name}} as {{col.name}}_black,
  {% endfor %} 
   
from {{ ref('mrt_filtered_twicgames') }} tg 
inner join static_game_stats sgs on tg.id = sgs.game_id
left join {{ ref('mrt_player_stats') }} ps_white on ps_white.game_id = tg.id and tg.white_fide_id = ps_white.player_id
left join {{ ref('mrt_player_stats') }} ps_black on ps_black.game_id = tg.id and tg.black_fide_id = ps_black.player_id
--where tg.white_fide_id = 751871
--or tg.black_fide_id = 751871



