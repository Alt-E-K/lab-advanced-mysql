#CHALLENGE 1
use publications;

 select a.au_id, a.au_fname, a.au_lname ,round(total_advance+total_royalty_title,0) as total_profit from (select au_id, title_id, avg(advance_per_au) as total_advance, sum(royalty_per_sale) as total_royalty_title from (
	SELECT s.title_id, 
    ta.au_id,
    t.advance, 
    ta.royaltyper, 
    round(t.advance * (ta.royaltyper / 100),0) as advance_per_au,
    t.price, s.qty, t.royalty,  round(t.price * s.qty * (t.royalty / 100 )* (ta.royaltyper / 100), 0) as royalty_per_sale

		from sales as s
		join titles as t
		on t.title_id=s.title_id
		join titleauthor as ta
		on ta.title_id=s.title_id) as step2


group by  au_id, title_id) as step3
join authors as a
on a.au_id=step3.au_id
group by au_id
order by total_profit DESC
limit 3


#CHALLENGE 2

create temporary table step_1
	SELECT s.title_id, 
    ta.au_id,
    t.advance, 
    ta.royaltyper, 
    round(t.advance * (ta.royaltyper / 100),0) as advance_per_au,
    t.price, s.qty, t.royalty,  round(t.price * s.qty * (t.royalty / 100 )* (ta.royaltyper / 100), 0) as royalty_per_sale

		from sales as s
		join titles as t
		on t.title_id=s.title_id
		join titleauthor as ta
		on ta.title_id=s.title_id

^^^^

create temporary table step2

select title_id,
 au_id, 
avg(advance_per_au) as advance,
sum(royalty_per_sale) as royaltyes_per_title from step_1
 
group by title_id, au_id

^^^^

select a.au_id, 
a.au_fname, 
a.au_lname ,
round(advance+royaltyes_per_title,0) as total_profit from step2
 
join authors as a
on a.au_id=step2.au_id
group by au_id
order by total_profit DESC
limit 3

#CHALLENGE3

create table most_profiting_authors 
select a.au_id,round(advance+royaltyes_per_title,0) as total_profit from step2
group by au_id
order by total_profit DESC
