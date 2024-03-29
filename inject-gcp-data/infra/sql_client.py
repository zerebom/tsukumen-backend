import sqlite3
from sqlite3 import Error


class SQLClient:
    def __init__(self, db_file):
        self.conn = self.create_connection(db_file)

    def insert_single_row(self, table, columns, data):
        place_holders = tuple(['?' for _ in range(len(columns))])

        with self.conn:
            sql = f''' INSERT INTO {table}({', '.join(columns)})
            VALUES ({','.join(place_holders)}) '''

            cur = self.conn.cursor()
            cur.execute(sql, tuple(data))
            self.conn.commit()

    def insert_many_rows(self, table, columns, data_list):
        place_holders = tuple(['?' for _ in range(len(columns))])
        with self.conn:
            sql = f''' INSERT INTO {table}({', '.join(columns)})
            VALUES ({','.join(place_holders)}) '''

            cur = self.conn.cursor()
            # import pdb ;pdb.set_trace()
            cur.executemany(sql, tuple(data_list))
            self.conn.commit()

    def delete_all_data(self, tables):
        if type(tables) == str:
            tables = list(tables)

        for table in tables:
            sql = f''' DELETE FROM {table}'''
            cur = self.conn.cursor()
            cur.execute(sql)

            # re-indexするには下記SQL文も必要.
            sql = f''' DELETE FROM sqlite_sequence where name='{table}' '''
            cur = self.conn.cursor()
            cur.execute(sql)

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
