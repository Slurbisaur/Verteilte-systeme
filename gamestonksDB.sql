DROP TABLE IF EXISTS developers, dlc, genres, games, users, publishers, games_owned, playtime, dlcs_owned CASCADE;

CREATE TABLE genres
(genreid integer NOT NULL,
 genre_name VARCHAR(30),
 PRIMARY KEY (genreid));
 
INSERT INTO genres(genreid, genre_name)
 VALUES (1, 'Shooter'), (2, 'RPG'), (3, 'MOBA'), (4, 'Simulator'), (5, 'Indie');


CREATE TABLE publishers(
 publisher_id serial NOT NULL,
 pub_name VARCHAR(30) NOT NULL,
 PRIMARY KEY (publisher_id));

INSERT INTO publishers(publisher_id, pub_name)
 VALUES (1, 'Electronic Arts'),(2, 'CD Projekt Red'),(3, 'Tencent'),(4, 'Riot Games'),(5, 'Nicalis, Inc.'),(6, 'Gamera');


CREATE TABLE developers
(devid integer NOT NULL,
 dev_name VARCHAR(30) NOT NULL,
 publisher_id integer NOT NULL REFERENCES developers(devid) ON DELETE CASCADE,
 PRIMARY KEY (devid));

INSERT INTO developers(devid, dev_name, publisher_id)
 VALUES (1, 'Respawn', 1), (2, 'CD Projekt Red', 2),
 (3, 'DICE', 1), (4, 'PUBG Corporation', 3), (5, 'Riot Games', 4),
 (6, 'Edmund McMillen', 5), (7, 'Youthcat Studio', 6),(8, 'Maxis', 1);


CREATE TABLE games
(gameid integer NOT NULL,
 game_name VARCHAR(30) NOT NULL,
 genreid integer REFERENCES genres(genreid) ON DELETE CASCADE,
 devid integer REFERENCES developers(devid) ON DELETE CASCADE,
 price    decimal(10,2),
 currency char(3),
 FOREIGN KEY (genreid) REFERENCES genres(genreid),
 FOREIGN KEY (devid) REFERENCES developers(devid),
 PRIMARY KEY (gameid)
);
 
INSERT INTO games(gameid, game_name, genreid, devid, price, currency)
 VALUES (1,'Cyberpunk 2077', 2, 2, 59.99, 'EUR'), (2, 'The Witcher 3', 2, 2, 29.99, 'EUR'), (3, 'League of Legends', 3, 5, 0.00, 'EUR'), (4, 'Valorant', 1, 5, 0.00, 'EUR'), 
 (5,'Legends of Runeterra', 4, 5, 0.00, 'EUR'),(6, 'Battlefield 4', 1, 3, 19.99, 'EUR'),(7, 'Battlefield 1', 1, 3, 39.99, 'EUR'),(8, 'Titanfall 2', 1, 1, 17.99, 'EUR'),
 (9, 'Dyson Sphere Program', 5, 7, 19.99, 'EUR'), (10, 'The Binding of Isaac: Rebirth', 5, 6, 14.99, 'EUR'), (11, 'PUBG', 1, 4, 29.99, 'EUR'),(12, 'Spore', 4, 8, 19.99, 'EUR');


CREATE TABLE dlc
(gameid integer NOT NULL REFERENCES games(gameid) ON DELETE CASCADE,
 dlc_name VARCHAR(30) NOT NULL,
 price    decimal(10,2),
 currency char(3),
 PRIMARY KEY (gameid, dlc_name));
 
INSERT INTO dlc(gameid, dlc_name, price, currency)
 VALUES (2, 'Blood & Wine', 19.99, 'EUR'), (2, 'Hearts of Stone', 9.99, 'EUR'),
 (06, 'Final Stand', 19.99, 'EUR'),(06, 'China Rising', 19.99, 'EUR'),(06, 'Second Assault', 19.99, 'EUR'),
 (06, 'Naval Strike', 19.99, 'EUR'),
 (07, 'Apocalypse', 14.99, 'EUR'),(07, 'Turning Tides', 14.99, 'EUR'),(07, 'In the name of the Tsar', 14.99, 'EUR'),
 (07, 'They shall not pass', 14.99, 'EUR'), 
 (10, 'Afterbirth', 10.99, 'EUR'), (10, 'Afterbirth+', 10.99, 'EUR'),(10, 'Repentance', 12.49, 'EUR');



CREATE TABLE users
(stonksid       serial NOT NULL,
 uname           VARCHAR(30)   NOT NULL,
 fav_gameid       integer, --No delete Cascade because user profiles should never be deleted when their favorite game is deleted
 PRIMARY KEY   (stonksid));

INSERT INTO users(uname, stonksid, fav_gameid)
 VALUES ('max-musterfrau',56423, 9),('Knodel',784521,3),('slurbisaur',221016, 10),('Mukagen',23164, 11),('Vinesauce',2315, 11),
 ('shroud',51337, 4),('Petko',14208, 2),('Ninja',1885, 1),('dosia_Xgod',1, 4),('Pokimane',1695, 3);



CREATE TABLE games_owned
(stonksid integer REFERENCES users(stonksid) ON DELETE CASCADE,
 gameid   integer REFERENCES games(gameid) ON DELETE CASCADE,
 PRIMARY KEY (stonksid, gameid));
 
INSERT INTO games_owned(stonksid, gameid)
 VALUES (221016, 1), (221016, 2), (221016, 10), (221016, 12), (221016, 6),(221016, 11),
 (56423, 8), (56423, 7), (56423, 1), (56423, 11), (56423, 6), (56423, 9),
 (784521, 1), (784521, 3), (784521, 4), (784521, 6), (784521, 7), (784521, 11),
 (23164, 12),
 (2315, 3), (2315, 5), (2315, 4),
 (51337, 4), (51337, 11),
 (14208, 11), (14208, 7), (14208, 10),
 (1885, 4), (1885, 11),(1885, 6),
 (1, 1), (1, 3), (1, 5),
 (1695, 3), (1695, 4);


CREATE TABLE dlcs_owned
(stonksid integer REFERENCES users(stonksid) ON DELETE CASCADE,
 gameid   integer REFERENCES games(gameid) ON DELETE CASCADE,
 dlc_name   VARCHAR(30),
 PRIMARY KEY (stonksid, gameid, dlc_name));
 

INSERT INTO dlcs_owned(stonksid, gameid, dlc_name)
 VALUES (221016, 2, 'Blood & Wine'),(221016, 2, 'Hearts of Stone'),(221016, 10, 'Aafterbirth'),(221016, 10, 'Afterbirth+'),(221016, 10, 'Repentance'),(784521, 2, 'Blood & Wine'),(784521, 2, 'Hearts of Stone'),(56423, 2, 'Blood & Wine'),(56423, 2, 'Hearts of Stone'),
 (56423, 6, 'Final Stand'), (56423, 6, 'China Rising'), (56423, 6, 'Second Assault'), (56423, 6, 'Naval Strike'),(784521, 6, 'Final Stand'), (784521, 6, 'China Rising'), (784521, 6, 'Second Assault'), (784521, 6, 'Naval Strike'), (14208, 7, 'Apocalypse'), (14208, 7, 'They shall not pass');


CREATE TABLE playtime
(stonksid integer REFERENCES users(stonksid) ON DELETE CASCADE,
 gameid   integer REFERENCES games(gameid) ON DELETE CASCADE,
 playtime_hours integer, 
 PRIMARY KEY (stonksid, gameid));

 INSERT INTO playtime(stonksid, gameid, playtime_hours)
 VALUES(221016, 10, 2512),(221016, 1, 53),(221016, 7, 128),(221016, 2, 174),(221016, 11, 26),
 (784521, 1, 48),(784521, 2, 78),(784521, 3, 6383),(784521, 4, 8),(784521, 6, 212),(784521, 7, 2),(784521, 11, 215),
 (1695, 3, 16230),(1695, 4, 577),
 (56423, 1, 44),(56423, 9, 32),(56423, 8, 2124),(56423, 7, 50),(56423, 6, 114),(56423, 2, 114);

CREATE OR REPLACE VIEW playtime_with_text AS 
  SELECT users.stonksid, users.uname, games.gameid, games.game_name, playtime.playtime_hours
  FROM playtime
  JOIN users ON playtime.stonksid = users.stonksid
  JOIN games ON playtime.gameid = games.gameid;

CREATE OR REPLACE VIEW playtime_total AS
  SELECT SUM(playtime_hours), gameid FROM playtime GROUP BY gameid;
