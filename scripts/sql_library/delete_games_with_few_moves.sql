delete from twicgames
where id in (
	select id
	from (
		select id, moves, LENGTH(moves) as move_length
		from twicgames
		order by move_length asc
	) t
	where t.move_length < 8
)
