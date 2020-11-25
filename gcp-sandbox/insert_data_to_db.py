#%%
import sqlite3
from sqlite3 import Error
from datetime import date, datetime, timedelta
import pprint # list型やdict型を見やすくprintするライブラリ

import googlemaps
#serct ex): https://dev.mysql.com/doc/connector-python/en/connector-python-example-cursor-select.html
# insert ex): https://dev.mysql.com/doc/connector-python/en/connector-python-example-cursor-transaction.html


class BuildDBData:
    '''
    GoogleAPIをSQLに格納できる形に変換するクラス
    '''

    def __init__(self,place_dic:dict,shop_id=0):
        self.place_dic = place_dic
        self.shop_id = shop_id

    def shop(self):
        return_dic = {}
        return_dic['name'] = self.place_dic['name']
        return_dic['phone_number'] = self.place_dic['formatted_phone_number']
        return_dic = self._add_timedate(return_dic)
        return return_dic

    def reviews(self):
        return_dic_list = []
        reviews = self.place_dic['reviews']
        name_corespondence = {'author_name':'reviewer','text':'review_text','rating':'star'}

        for review in reviews:
            if review['language'] != 'ja':
                continue

            return_dic = {}
            for gcp_name, db_name in name_corespondence.items():
                    return_dic[db_name] = review[gcp_name]
                    return_dic['shop_id'] = self.shop_id
                    return_dic = self._add_timedate(return_dic)

            return_dic_list.append(return_dic)

        return return_dic_list

    def address(self):
        return_dic = {}

        adrs = self.place_dic['address_components']
        loc = self.place_dic['geometry']['location']

        return_dic['latitude'] = loc['lat']
        return_dic['longitude'] = loc['lng']
        return_dic = self._add_address_data(return_dic,adrs)
        return_dic = self._add_timedate(return_dic)
        return return_dic


    def _add_timedate(self,dic):
        time = datetime.now()
        dic['created_at'] = time
        dic['updateed_at'] = time
        return dic

    def _add_address_data(self,dic,adrs):

        #gcp_name:db_nameの対応表
        name_corespondence = {'postal_code':'postal_code',
                              'administrative_area_level_1':'prefecture',
                              'locality':'locality',
                              'sublocality':'thoroughfare',
                              'premise':"sub_thoroughfare"}

        for val in adrs:
            for gcp_name, db_name in name_corespondence.items():
                if gcp_name in val['types']:
                    dic[db_name] = val['short_name']

        return dic



class SQLClient:
    def __init__(self,db_file):
        self.conn = self.create_connection(db_file)

    def insert_single_row(self,table,columns,data):
        place_holders = tuple(['?' for _ in range(len(columns))])

        with self.conn:
            sql = f''' INSERT INTO {table} {columns}
                        VALUES {place_holders} '''

            cur = self.conn.cursor()
            cur.execute(sql, data)
            self.conn.commit()

    def insert_many_rows(self,table,columns,data_list):
        place_holders = tuple(['?' for _ in range(len(columns))])
        with self.conn:
            sql = f''' INSERT INTO {table} {columns}
                        VALUES {place_holders} '''

            cur = self.conn.cursor()
            cur.executemany(sql, data_list)
            self.conn.commit()

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


#%%

def main():
    with open('../GCP_API_KEY','r') as f:
        API_KEY = f.read()


    client = googlemaps.Client(API_KEY) #インスタンス生成
    geocode_result = client.geocode('つくば市') # 位置情報を検索
    loc = geocode_result[0]['geometry']['location'] # 軽度・緯度の情報のみ取り出す

    db_file = '../db/development.sqlite3'
    #半径20kmのラーメン屋を収集
    place_result = client.places_nearby(location=loc, radius=20000, type='food',language='ja',keyword='らーめん') #半径200m以内のレストランの情報を取得

    place_details = client.place(place_id='ChIJ_wXNP1ypGGARZBldsBUqe-A',language='ja')
    detail_data = place_details['result']



    bdt = BuildDBData(detail_data)
    print(bdt.address())
    print(bdt.shop())
    print(bdt.reviews())


















