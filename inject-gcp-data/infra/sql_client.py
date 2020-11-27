import sqlite3
from sqlite3 import Error

class SQLClient:
    def __init__(self,db_file):
        self.conn = self.create_connection(db_file)

    def insert_single_row(self,table,columns,data):
        place_holders = tuple(['?' for _ in range(len(columns))])

        with self.conn:
            sql = f''' INSERT INTO {table}({', '.join(columns)})
            VALUES ({','.join(place_holders)}) '''

            cur = self.conn.cursor()
            cur.execute(sql, tuple(data))
            self.conn.commit()

    def insert_many_rows(self,table,columns,data_list):
        place_holders = tuple(['?' for _ in range(len(columns))])
        with self.conn:
            sql = f''' INSERT INTO {table}({', '.join(columns)})
            VALUES ({','.join(place_holders)}) '''

            cur = self.conn.cursor()
            cur.executemany(sql, tuple(data_list))
            self.conn.commit()

    @staticmethod
    def create_connection(db_file):
        """ create a database connection to the SQLite database
            specified by db_file
        :param db_file: database file
        :return: Connection object or None
        """
        conn = None
        try:
            conn = sqlite3.connect(db_file)
        except Error as e:
            print(e)
        return conn
