create database ipl

use ipl;

select * from deliveries;
select * from matches;

desc matches

-- Q1 WHAT ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS? 
select player_of_match, count(*) as no_of_match
from matches
group by  player_of_match 
order by no_of_match desc
limit 5


-- Q2 HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?
select team1, count(winner) as no_of_winner, season
from matches
group by team1, season
order by season

-- Q3 WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?
select batsman, count(*)as No_of_balls, sum(total_runs) as total_runs,(sum(total_runs)/count(*))*100 as strik_rate
from deliveries
group by batsman
order by total_runs desc


select avg(strik_rate) as avg_of_strike_rate
from(
	select batsman, count(*)as No_of_balls, sum(total_runs) as total_runs,(sum(total_runs)/count(*))*100 as strik_rate
	from deliveries
	group by batsman
	order by total_runs desc) as A
    
    
-- Q4 WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTINGSECOND?
select Toss_decision, toss_winner
from matches
where toss_decision ="bat"

select batting_first , count(*) as match_wons
from(
		select case 
				when win_by_runs >0 then team1
				else team2
				end
				as batting_first 
		from matches 
		where winner != "tie"
 ) as batting_first_team
 group by batting_first



-- Q5 WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?
select batsman , (sum(total_runs)/count(*))*100 as strickr_rate
from deliveries
group by batsman
having (sum(total_runs)/count(*))*100  >200


-- Q6 HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?
select batsman , count(*) as total_dissmiss
from deliveries
where player_dismissed is not null and  bowler = "SL Malinga"
group by batsman
order by total_dissmiss desc
-- having sum(batsman_runs)= 0


-- Q7 WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXESCOMBINED) HIT BY EACH BATSMAN?
select batsman, avg(case 
					when batsman_runs = 4 or batsman_runs = 6  then 1 else 0
                    end
                    )*100 as average
from deliveries
group by batsman
order by average desc

-- Q8 WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?
select batting_team , avg(case 
		when batsman_runs = 4 or batsman_runs = 6
        then 1 else 0 
        end) as average, m.season
from deliveries 
group by batting_team

-- Q9 WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?
select max(partnership), season
from(
		select d.batsman, d.non_striker, sum(d.total_runs) as partnership, m.season
		from deliveries as d
		inner join matches as m 
		on d.match_id = m.id
		group by d.batsman,d.non_striker, m.season
		order by partnership desc
) as A 
group by season


-- Q10 HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?
select match_id,bowler , bowling_team , sum(extra_runs) as total_extra
from deliveries
group by bowling_team, bowler,match_id
order by total_extra desc

-- Q11 WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLEMATCH?
select  match_id, bowler , bowling_team, count(*) as wickets
from (
		select bowler , bowling_team, count(*) as wickets, match_id
		from deliveries
		where player_dismissed is not null
		group by bowling_team, bowler, match_id
		order by wickets desc
)a
group by bowling_team, bowler, match_id
order by match_id desc

-- Q12 HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?
select winner, city , count(*) as no_of_match_win
from matches 
group by winner, city
order by no_of_match_win desc

-- Q13 HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?
select toss_winner, season , count(*) as no_of_win
from matches
group by toss_winner, season

-- Q14 HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?
select player_of_match, count(*) as no_of_winner
from matches
group by player_of_match
order by no_of_winner desc

-- Q15 WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS INEACH MATCH?
select over -- , avg(total_runs) as avgerage_of_runs, mathc_id, batting_team, bowling_team
from deliveries
group by over


-- Q16 WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?

select sum(total_runs) as highest_score, batting_team, match_id
from deliveries
group by batting_team, match_id
order by highest_score desc

-- Q17 WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?
select batsman , sum(total_runs) as highest_score, match_id
from deliveries
group by batsman, match_id
order by highest_score desc