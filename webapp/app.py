from flask import Flask, render_template, request
import psycopg2
import psycopg2.extras

app = Flask(__name__)


def connectToDatabase():
    conn_str = "dbname=stonksDB user=postgres host=localhost"
    return psycopg2.connect(conn_str)


@app.route("/")
def Index():
    return render_template("index.html")

@app.route("/users")
def showUsers():
    conn = connectToDatabase()
    cur = conn.cursor()
    cur.execute("SELECT users.stonksid, users.uname, games.game_name FROM users LEFT OUTER JOIN games ON users.fav_gameid=games.gameid")
    results = cur.fetchall()
    return render_template("users.html", userList=results)

@app.route("/addusers", methods=["GET", "POST"])
def addUsers():
    conn = connectToDatabase()
    cur = conn.cursor()
    cur.execute("SELECT * from games")
    games = cur.fetchall()
    new_pkey = 0
    addeduser = 0
    if request.method == "POST":
        cur.execute("SELECT max(stonksid) FROM users")
        new_pkey = cur.fetchall()[0][0]+1
        if int(request.form["favgameselect"]) != 0:
            favgame=request.form["favgameselect"]
        else:
            favgame=None
        cur.execute("INSERT INTO users (stonksid,uname,fav_gameid) VALUES (%s,%s,%s);", (new_pkey,request.form["uname"],favgame,))
        conn.commit()
        addeduser=request.form["uname"]
    return render_template("addusers.html", addeduser=addeduser, addeduserid=new_pkey, games=games)

@app.route("/gamesbypub", methods=["GET", "POST"])
def gamesbypub():
    conn = connectToDatabase()
    cur = conn.cursor()
    gamesbypub = 0
    cur.execute("""SELECT * FROM publishers""")
    pubs = cur.fetchall()
    if request.method =="POST":
        cur.execute(f"""SELECT games.gameid, games.game_name, developers.dev_name, genres.genre_name, games.price, games.currency, publishers.pub_name from (((games 
                        INNER JOIN developers ON games.devid=developers.devid)
                        INNER JOIN publishers ON developers.publisher_id=publishers.publisher_id) 
                        INNER JOIN genres ON games.genreid=genres.genreid)
                        WHERE publishers.publisher_id='{request.form["viewgamesbypub"]}'
                        ;""")
        gamesbypub = cur.fetchall()
    return render_template("gamesbypub.html", pubs=pubs, gamesbypub=gamesbypub)

@app.route("/changeusers", methods=["GET", "POST"])
def changeUsers():
    conn = connectToDatabase()
    cur = conn.cursor()
    cur.execute("SELECT * from games")
    games = cur.fetchall()
    if request.method == "POST":
        cur.execute("SELECT max(stonksid) FROM users")
        if int(request.form["favgameselect"]) != 0:
            favgame=request.form["favgameselect"]
        else:
            favgame=None
        cur.execute(f"""UPDATE users SET uname='{request.form["newuname"]}', fav_gameid={favgame} WHERE stonksid={request.form["stonksid"]};""")
        conn.commit()
    return render_template("changeusers.html", games=games)

@app.route("/viewusers", methods=["GET", "POST"])
def viewUsers():
    conn = connectToDatabase()
    cur = conn.cursor()
    cur.execute("SELECT * from games")
    moneyspent_games = 0
    moneyspent_dlcs = 0
    stonksid=0
    playtime = 0
    if request.method == "POST":
        stonksid=request.form["stonksid"]
        cur.execute(f"""SELECT SUM(games.price) FROM games_owned JOIN games ON games.gameid=games_owned.gameid WHERE stonksid={stonksid} """)
        moneyspent_games = cur.fetchall()[0][0]
        cur.execute(f"""SELECT SUM(dlc.price) FROM dlcs_owned JOIN dlc ON dlc.dlc_name=dlcs_owned.dlc_name WHERE stonksid={stonksid} """)
        temp = cur.fetchall()[0][0]
        if temp == None:
            moneyspent_dlcs = 0
        else:
            moneyspent_dlcs = temp
        cur.execute(f"""SELECT stonksid, game_name, playtime_hours FROM playtime_with_text WHERE stonksid={stonksid} """)
        playtime = cur.fetchall()
    return render_template("viewusers.html", moneyspent_games=moneyspent_games, moneyspent_dlcs=moneyspent_dlcs,stonksid=stonksid, playtime=playtime)    

@app.route("/deleteusers", methods=["GET", "POST"])
def deleteUsers():
    conn = connectToDatabase()
    cur = conn.cursor()
    cur.execute("SELECT * from games")
    games = cur.fetchall()
    if request.method == "POST":
        cur.execute(f"""DELETE FROM users WHERE stonksid = {request.form["stonksid"]}""")
       # cur.execute(f"""DELETE * FROM users INNER JOIN games_owned ON users.stonksid=games_owned.stonksid INNER JOIN dlcs_owned ON users.stonksid=dlcs_owned.stonksid INNER JOIN playtime ON users.stonksid=playtime.stonksid WHERE stonksid={request.form["stonksid"]}""")
        conn.commit()
    return render_template("deleteusers.html")

if __name__ == "__main__":
    app.run()

