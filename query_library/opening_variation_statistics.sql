with white_wins as 
(
	select opening, coalesce(variation, '-') as variation, "result", coalesce(count("result"),0) as white_wins
	from twicgames t2
	where "result" = '1-0'
	group by opening, variation, "result"
),
draws as (
	select opening, coalesce(variation, '-') as variation, "result", coalesce(count("result"),0) as draws
	from twicgames t2
	where "result" = '1/2-1/2'
	group by opening, variation, "result"
),
black_wins as (	
	select opening, coalesce(variation, '-') as variation, "result", coalesce(count("result"),0) as black_wins
	from twicgames t2
	where "result" = '0-1'
	group by opening, variation, "result"
),
opening_variation_combinations as (
	select distinct opening, coalesce(variation,'-') as variation
	from twicgames
)
select 
	comb.opening, 
	comb.variation, 
	ww.white_wins, 
	bw.black_wins,
	d.draws,
	ww.white_wins / (ww.white_wins + bw.black_wins + d.draws)::float as white_win_percentage,
	d.draws / (ww.white_wins + bw.black_wins + d.draws)::float as draw_percentage,
	bw.black_wins / (ww.white_wins + bw.black_wins + d.draws)::float as black_win_percentage
from opening_variation_combinations comb
inner join white_wins ww 
	on comb.opening = ww.opening 
	and comb.variation = ww.variation 
inner join black_wins bw 
	on comb.opening = bw.opening 
	and comb.variation = bw.variation
inner join draws d 
	on comb.opening = d.opening 
	and comb.variation = d.variation 
