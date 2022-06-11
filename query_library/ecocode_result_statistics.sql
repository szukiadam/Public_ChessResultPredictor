with white_wins as 
(
	select eco, "result", coalesce(count("result"),0) as white_wins
	from twicgames t2
	where "result" = '1-0'
	group by eco, "result"
),
draws as (
	select eco, "result", coalesce(count("result"),0) as draws
	from twicgames t2
	where "result" = '1/2-1/2'
	group by eco, "result"
),
black_wins as (	
	select eco, "result", coalesce(count("result"),0) as black_wins
	from twicgames t2
	where "result" = '0-1'
	group by eco, "result"
),
opening_variation_combinations as (
	select distinct eco
	from twicgames
)
select 
	comb.eco,
	ww.white_wins, 
	bw.black_wins,
	d.draws,
	ww.white_wins / (ww.white_wins + bw.black_wins + d.draws)::float as white_win_percentage,
	d.draws / (ww.white_wins + bw.black_wins + d.draws)::float as draw_percentage,
	bw.black_wins / (ww.white_wins + bw.black_wins + d.draws)::float as black_win_percentage
from opening_variation_combinations comb
inner join white_wins ww 
	on comb.eco = ww.eco 
inner join black_wins bw 
	on comb.eco = bw.eco 
inner join draws d 
	on comb.eco = d.eco 
