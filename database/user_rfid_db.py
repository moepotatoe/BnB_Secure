import os
import sqlite3
 
# Create DB in current file
DEFAULT_PATH = os.path.join(os.path.dirname(__file__), 'user.db')
CREATE_SQL_FILE = os.path.join(os.path.dirname(__file__), 'user_rfid.sql')
 
 
def db_connect(db_path=DEFAULT_PATH):
    connect = sqlite3.connect(db_path)
    return connect
 
 
def create_table():
    db_conn = db_connect()
 
    with db_conn:
        try:
            db_conn = db_connect()
            cursor = db_conn.cursor()
            print("Successfully Connected to SQLite")
 
            with open(CREATE_SQL_FILE, 'r') as sqlite_file:
                sql_script = sqlite_file.read()
 
            cursor.executescript(sql_script)
            print("SQLite script executed successfully")
            cursor.close()
 
        except sqlite3.Error as error:
            print("Error while executing sqlite script", error)
 
    print("Successfully created table!")
 
 
def insert_user(connect, user):
    """
    Create a new student task
    :param conn:
    :param student:
    :return:
    """
 
    sql = ''' INSERT INTO user(id, name, rfid_tag)
              VALUES(?,?,?) '''
    cur = connect.cursor()
    cur.execute(sql, user)
    connect.commit()
    return cur.lastrowid
 
 
def create_user():
    # create a database connection
    db_conn = db_connect()
 
    with db_conn:
        # sample users
        user1 = (1, 'Test user', "A4 F6 AF 4D")
        user2 = (2, 'calstate fullerton', "90 06 62 37")
        user3 = (3, 'cpsc 491', "04 18 5F F2 81 3B 80")
 
        # create users
        insert_user(db_conn, user1)
        insert_user(db_conn, user2)
        insert_user(db_conn, user3)
 
 
def main():
    create_table()
    create_user()
 
 
if __name__ == '__main__':
    main()