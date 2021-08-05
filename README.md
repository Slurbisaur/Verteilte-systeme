# VerteilteSysteme-StonksDB
*Databases Project contributor: Sebastian Hildenbeutel*

## Tables

1. For this project the main goal is to give the users a web-interface inform of a fictive statistical
Database to check their owned games, which developers they were made by and what publisher published
the game in question. 

2. The users are able to see things like the total amount of money spent on games and their respective dlc and 
playtime in their favourite games (and non favourite games).
This information is accessible to everyone.

3. To give the users of the StonksDB the best experience background queries, a variety of data outputs are
handled unseen by the user to give him/her a fast and responsive interface for tracking 
statistics, budget, investments and organization of the users games. 

4. Stored inside of the StonksDB are a variety of Tables:

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- A table for users with the primary key stonksID (User ID) and the attributes uname (the name of the user) as well\
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;as the user's favourite game as fav_gameID. 
  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- A table for the games available on the platform with primary gameID
  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- A table for genres which is directly coupled the games table to classify the genre of the game available.
  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Some games offer downloadable content, also called DLC.\
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;these are maintained in a separate table called dlc which keeps track of the gameID and the name of the dlc.
    
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Also included are the Tables developers and publishers. The developer table is dependant on the publisher table since\
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;developers need a publisher to promote and make their games available for the public. 
    
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Also included are tables for owned products games_owned, dlc_owned which map the games/dlc available on the platform to the users\ 
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;that already own them.

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- The total play-time of each user, spent in-game is saved in the table playtime.

12. Transactions are implemented by psycopg2, which was used for the web app. Any time a database connection is established or a commit is placed, it automatically starts a new transaction. A manual implementation of transactions is therefore omitted.

13. Views are explained in the section on queries as they are simply wrappers for predefined queries.
  


### First Normal Form

Table games
| gameid |    game_name     | genreid | devid | price | currency |
|--------|------------------|---------|-------|-------|----------|	 
|   1    | 'Cyberpunk 2077' |    2    |   2   | 59.99 |  'EUR'   |	 
|   2    |  'The Witcher 3' |    2    |   2   | 29.99 |  'EUR'   |	

Relations that have a composition of multi-valued attributes violate the first normal form
therefore all attributes are written atomically into their own columns.
If price would be in one column with the currency symbol the first norm form would be violated.



### Second Normal Form

Table users
|    uname     | stonksid | fav_gameid |
|--------------|----------|------------|
| 'miguel7501' |  56423   |     9      |
|     'sxd'    |  784521  |     3      |

Table games_owned
| stonksid | gameid |
|----------|--------|
|  221016  |   1    |
|  221016  |   2    |

all rules of the first normal form apply inclusive the absence of partial dependencies.
One user can own multiple games if we would store all games a user owns inside of one column inside of the users 
table we would violate the second normal form, therefore the two dependant tables are split.


### Third Normal Form

all rules of the second normal form apply inclusive the absence of transitive dependencies.
We intentionally designed the database in a way that no transitive dependencies could happen therefore
we can/did not violate the third normal form. 



### Weak entity 

The weak entity dlc (the primary key for the dlc table consists of foreign key gameID and dlc_name)

Table dlc
| gameID |    dlc_name    | price | currency |
|--------|----------------|-------|----------|
|   2    | 'Blood & Wine' | 19.99 |   'EUR'  |

This table is completely dependent on the existence of the games the downloadable content is created for. 


## Queries

1. The following query is used in the web application to display a list of users:
``` pgsql
SELECT users.stonksid, users.uname, games.game_name 
    FROM users LEFT OUTER JOIN games ON users.fav_gameid=games.gameid
```
It shows the content of the users table and shows the favourite game's name when possible.
If the name of the favourite game is not found in the games table, it still lists the user.

2. For showing a list of all games for a certain publisher, the web app uses this query:
``` pgsql
SELECT games.gameid, games.game_name, developers.dev_name, genres.genre_name, games.price, games.currency, publishers.pub_name 
    FROM (((games 
    INNER JOIN developers ON games.devid=developers.devid)
     INNER JOIN publishers ON developers.publisher_id=publishers.publisher_id) 
     INNER JOIN genres ON games.genreid=genres.genreid)
                        WHERE publishers.publisher_id='{request.form["viewgamesbypub"]}'
```
The publisher_id is supplied by the web app. The user can select one publisher from a dropdown by name.
This query gets all developers for the respective publisher from the developers table.
After that, the games table is used to find all the games made by those developers.
The query also accesses the genres table to display the name of the game's genre instead of the ID.

3. Selection of the total money spent on games and DLCs by a certain user
``` pgsql
SELECT SUM(games.price) FROM games_owned 
       JOIN games ON games.gameid=games_owned.gameid 
       WHERE stonksid={stonksid}
```
``` pgsql
SELECT SUM(dlc.price) FROM dlcs_owned 
       JOIN dlc ON dlc.dlc_name=dlcs_owned.dlc_name 
       WHERE stonksid={stonksid}
```
The games_owned table is used to find out which games/dlcs are owned by the user.
After that, the query gets the prices of those games/dlcs and sums them up.
Both values are added together by the web app.

4. For displaying the time a certain user has spent in games, a view is used. Since this view is basically a query, it is explained in this section.
``` pgsql
CREATE OR REPLACE VIEW playtime_with_text AS 
  SELECT users.stonksid, users.uname, games.gameid, games.game_name, playtime.playtime_hours
  FROM playtime
  JOIN users ON playtime.stonksid = users.stonksid
  JOIN games ON playtime.gameid = games.gameid;
```
The query gets all the time every player has spent in every game from the playtime table.
It then accesses the users and games tables to get the usernames and game names.
The field stonksid is kept so that the view can later be accessed fromt the web app with this key:
``` pgsql
SELECT stonksid, game_name, playtime_hours 
  FROM playtime_with_text 
  WHERE stonksid={stonksid}
```

5. Some additional queries which were not implemented in the web app:

This view gets the most popular games by total playtime.
``` pgsql
CREATE OR REPLACE VIEW playtime_total AS
  SELECT SUM(playtime_hours), gameid FROM playtime GROUP BY gameid;
```
Since it is a view, it can be accessed like a table and complex operations can easily be implemented without resorting to subqueries, which makes it easier to develop and read.

