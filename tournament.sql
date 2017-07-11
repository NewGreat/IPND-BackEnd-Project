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
drop view if exists wins cascade;
drop view if exists games cascade;
drop view if exists standings cascade;
create table players (player_id serial primary key, name text);
create table matches (match_no serial primary key, winner integer references players(player_id), loser integer references players(player_id));

create view wins as select players.player_id, players.name, count (matches.winner) as wins
    from players left join matches
    on players.player_id = matches.winner
    group by players.player_id;

create view games as select players.player_id, players.name, count (matches.loser + matches.winner) as total_games
    from players left join matches
    on players.player_id = matches.winner or players.player_id = matches.loser
    group by players.player_id;

create view standings as select players.player_id, players.name, wins.wins, games.total_games
    from players left join wins
    on players.player_id = wins.player_id
    left join games
    on players.player_id = games.player_id
    order by wins desc;

