# ChessResultPredictor - Decision logs

*TODOS*
1. Stockfish static eval parser
1. Stockfish engine analysis

## Week 1
1. Problem 1: how to transform games into positions while still making it possible to see the flow of the game 
    1. Ideas:
        1. Cut your table into smaller pieces and save them as .csv in AWS S3
        1. Query ~10K games every time, then iterate over them 1 by 1 to get the FEN positions. After a certain amount write them out to a csv. Insert the rows inside the csv to the destination table. Update those records that we have already checked.
1. **Removed games** that were **missing their moves** (~5800 games)
1. Also **removed games where LENGTH(moves) was less than 8**. (~2300 games)
1. As we are in the **first iteration**, I'll only **extract positions from 10.000 games**. This will be **0.07GB** based on my calculations if I store them in a csv file, so the whole thing will sum up to 70GB. (~10 million games). **10K games took ~5 minutes.** 
1. I **extracted** various information from the **FEN** string to make it more **easily digestable** + to enable myself to later on create a table ONLY for the positions themselves, because I realized that every single FEN contains important information about the game as well. 
1. I realized that I'll **need to store the played move** in the game_positions db as well, because the FEN doesn't contain that information. 
1. Decided to use **both san and uci moves** to easily distinguish which piece has moved (san) and from where (uci)
1. Out of ~930K positions 800K were unique, after 10K games.  

## Week 2 
1. Asked the following question in Stockfish discord channel:
    > Hello guys, I would like to analyse a lot of positions with Stockfish for my thesis project, but I'm unsure on what's the most optimal way to do this. As most of the project is written in Python, I tried using python-chess, but it's not optimized for performance and I need to be able to analyse each position faster. What do you think is the best way to do this? (Sorry if this is not the correct place to ask this question, I've been looking around to find the proper channel, but I'm still unsure)
1. Question: what do I want to know about a position (what attributes should I have in that table?)
    1. Lichess cloud evaluation (https://lichess.org/api#operation/apiCloudEval)
        1. FEN 
        1. Knodes
        1. Depth
        1. Pvs (sometimes only one) = variations
            1. Moves
            1. Cp (evaluation)
    1. Lichess masters database endpoint (https://lichess.org/api#operation/openingExplorerMaster) + lichess all games database endpoint (https://lichess.org/api#operation/openingExplorerLichess)
        1. Customizable inputs
            1. Speeds(format of games): **blitz | rapid | classical | correspondence**
            1. Ratings: specify the rating group (1600,1800,2000,2200,2500)
        1. Number of games resulting in **white, draws, black**
        1. Top games
        1. Recent games
        1. Moves 
            1. Average rating
            1. Number of white, draws, black results
        1. ***QUESTION: do I want to know to which positions I can transition into?*** -> Yes, once we know the starting position (FEN) and the played move (uci or san format) we can deduct what is the resulting position. **Decision: For now it's too much complication, add it in a later iteration if we have the time.**  
            1. *** How can we store these transpositions?*** -> Have a bridge table for it. 
                1. Example: start_pos_id | resulting_pos_id 
    1. 

## Week 3:
    1. How to make sure that I'm only using data from the past ? 
        1. When calculating metrics I could add a date where the data is valid. (E.g. player_id | date | games_played)
        1. Ideated a bit more on potential features
        1. MLFlow is working with EC2 and S3 
        1. Faced a big issue: couldn't move dbt files and folders into subdirectory, so the project structure has suffered from this. 

*TODO: Script for position analysis*

## Week ..

`--bookfile book/book.bin`

Quick maths: on a **t2 micro** instance
- one hour is 0.0116 $
- on avg a position takes 5 seconds to analyse
  - 720 positions / hour for $0.0116 -> 720
- 100.000 positions can be analysed from $1.6
- 100.000 games x 40 position/game = 4.000.000 positions
- 4.000.000 / 100.000 = 40 * 1.6$ = 64$
- Others recommended c4.8large
- However C5's might be even better!
  - C5.4xlarge 2 threads 1024 CPU: 20 positions -> 39s
  - C5.4xlarge 4 threads 1024 CPU: 20 positions -> 30s
  - C5.4xlarge 8(/7) threads 1024 CPU: 20 positions -> 23s
  - C5.4xlarge 12 threads 1024 CPU: 20 positions -> 23s
  - C5.4xlarge 15 threads 1024 CPU: 20 positions -> 25s
- C5.xlarge is enough as it provides 4 vCPUs with 8GB RAM for $0.17 per hour.
  - from $0.17 i can analyse: 3600 / 1.2 = 3000 positions -> $0.17 = 3000 positions
  - 1 day ($4.08) = 72.000 positions (~1200games), 1 week = 504.000 ($28.56)
  - 504.000 positions ~ 8400 games
- GOAL: analyse 1.000 games -> ~60.000 positions
- Decision: Considering what's above, in the first iteration I'll only analyse games between hungarian players AND classical games. The query for that is the following (~3.7K games):
```sql
select *
from chess_thesis.stg_twicgames tg
inner join chess_thesis.fide_players fp_white on fp_white.fide_id = tg.white_fide_id
inner join chess_thesis.fide_players fp_black on fp_black.fide_id = tg.black_fide_id
where fp_white.federation = 'HUN'
and fp_black.federation = 'HUN'
and UPPER(tg.event) NOT LIKE '%RAPID%'
and UPPER(tg.event) NOT LIKE '%BLITZ%'
```

`LEAKAGE in mrt_opening_stats_for_game.sql` , but is it a problem?
- Potential solution: calculate averages only on the train set, and save this value. THen move this value over to the test dataset.