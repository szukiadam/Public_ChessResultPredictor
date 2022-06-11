with white_games as 
(
	select white, count(white) as white_games_count
	from twicgames
	group by white
	order by white_games_count desc 
),
black_games as (
	select black, count(black) as black_games_count
	from twicgames
	group by black
	order by black_games_count desc 
)
select white, white_games.white_games_count + black_games.black_games_count as total_games
from white_games
inner join black_games
on white_games.white = black_games.black

