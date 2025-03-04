-- Copyright 2004-2025 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

SET TIME ZONE '-8:00';
> ok

SELECT CAST(CURRENT_TIME AS TIME(9)) = LOCALTIME;
>> TRUE

SELECT CAST(CURRENT_TIME(0) AS TIME(9)) = LOCALTIME(0);
>> TRUE

SELECT CAST(CURRENT_TIME(9) AS TIME(9)) = LOCALTIME(9);
>> TRUE

SET TIME ZONE LOCAL;
> ok

select length(curtime())>=8 c1, length(current_time())>=8 c2, substring(curtime(), 3, 1) c3;
> C1   C2   C3
> ---- ---- --
> TRUE TRUE :
> rows: 1

select length(now())>18 c1, length(current_timestamp())>18 c2, length(now(0))>18 c3, length(now(2))>18 c4;
> C1   C2   C3   C4
> ---- ---- ---- ----
> TRUE TRUE TRUE TRUE
> rows: 1

SELECT CAST(CURRENT_TIME AS TIME(9)) = LOCALTIME;
>> TRUE

SELECT CAST(CURRENT_TIME(0) AS TIME(9)) = LOCALTIME(0);
>> TRUE

SELECT CAST(CURRENT_TIME(9) AS TIME(9)) = LOCALTIME(9);
>> TRUE

EXPLAIN SELECT CURRENT_TIME, LOCALTIME, CURRENT_TIME(9), LOCALTIME(9);
>> SELECT CURRENT_TIME, LOCALTIME, CURRENT_TIME(9), LOCALTIME(9)
