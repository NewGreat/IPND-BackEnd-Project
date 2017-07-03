-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

\c tournament
drop table if exists players cascade;
drop table if exists matches cascade;
drop view if exists standings cascade;
create table players (player_id serial primary key, name text);
create table matches (match_no serial primary key, winner integer references players(player_id), loser integer references players(player_id));
create view standings as select players.player_id, players.name, count (matches.winner) as wins, count (matches.match_no) as games from players 
    left join matches on players.player_id = matches.winner or players.player_id = matches.loser group by players.player_id order by wins desc;