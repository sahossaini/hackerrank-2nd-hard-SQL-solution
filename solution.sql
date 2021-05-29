with filt_cont as (
    select distinct c.contest_id
    , c.hacker_id
    , c.name
    , chl.challenge_id
    from contests c
    join colleges cl    on cl.contest_id = c.contest_id
    join challenges chl on chl.college_id = cl.college_id
)
, filt_ss as (
    select fc.contest_id
    , sum(ss.total_submissions) total_submissions
    , sum(ss.total_accepted_submissions) total_accepted_submissions 
    from filt_cont fc
    join submission_stats ss on ss.challenge_id = fc.challenge_id
    group by fc.contest_id
)
, filt_vs as (
    select fc.contest_id
    , sum(vs.total_views) total_views
    , sum(vs.total_unique_views) total_unique_views
    from filt_cont fc
    join view_stats vs on vs.challenge_id = fc.challenge_id
    group by fc.contest_id
)
select * 
from (
    select c.*
    , fs.total_submissions
    , fs.total_accepted_submissions
    , vs.total_views
    , vs.total_unique_views
    from contests c
    left join filt_ss fs on fs.contest_id = c.contest_id
    left join filt_vs vs on vs.contest_id = c.contest_id
) 
where nvl(total_submissions, 0)
    + nvl(total_accepted_submissions, 0)
    + nvl(total_views, 0)
    + nvl(total_unique_views, 0) != 0
order by contest_id;
