import pprint  # list型やdict型を見やすくprintするライブラリ

import googlemaps

from .infra.data_builder import BuildDBData
from .infra.sql_client import SQLClient


def get_search_center(client):
    '''検索の中心地を取得'''
    geocode_result = client.geocode('つくば市')  # 位置情報を検索
    loc = geocode_result[0]['geometry']['location']  # 軽度・緯度の情報のみ取り出す
    return loc


def get_api_key(API_PATH='../GCP_API_KEY'):
    with open(API_PATH, 'r') as f:
        return f.read()


def insert_data_to_db(shop_id, sql_client, place_details):
    '''place_details APIを整形してDBに挿入する.'''
    bdt = BuildDBData(place_details['result'], shop_id, return_sql_format=True)

    sql_client.insert_single_row('addresses', *bdt.address())
    sql_client.insert_single_row('shops', *bdt.shop())

    if not bdt.reviews():
        sql_client.insert_many_rows('reviews', *bdt.reviews())


def main(DB_PATH='../db/development.sqlite3'):
    sql_client = SQLClient(DB_PATH)
    client = googlemaps.Client(get_api_key())  # インスタンス生成

    next_page_token = None
    while True:
        shop_id = 0
        #TODO: loggerを作成する
        print('insert')

        place_result = client.places_nearby(location=get_search_center(client),
                                            radius=200000,
                                            type='food',
                                            language='ja',
                                            keyword='らーめん',
                                            page_token=next_page_token)

        if place_result['status'] != 'OK':
            break

        for result in place_result['results']:
            place_details = client.place(place_id=result['place_id'],
                                         language='ja')

            insert_data_to_db(shop_id, sql_client, place_details)
            shop_id += 1

        if not 'next_page_token' in place_result:
            break
        next_page_token = place_result['next_page_token']


if __name__ == "__main__":
    main()
