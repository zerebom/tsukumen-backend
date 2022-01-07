import os
import pprint  # list型やdict型を見やすくprintするライブラリ
from pathlib import Path

import googlemaps

from infra.data_builder import BuildDBData
from infra.logger import get_logger
from infra.sql_client import SQLClient


def get_search_center(client):
    """検索の中心地を取得"""
    geocode_result = client.geocode("つくば市")  # 位置情報を検索
    loc = geocode_result[0]["geometry"]["location"]  # 軽度・緯度の情報のみ取り出す
    return loc


def get_api_key(API_PATH="./GCP_API_KEY"):
    with open(API_PATH, "r") as f:
        return f.read()


def insert_data_to_db(client, shop_id, sql_client, place_details):
    """place_details APIを整形してDBに挿入する."""
    bdt = BuildDBData(place_details["result"], shop_id, return_sql_format=True)

    sql_client.insert_single_row("addresses", *bdt.address())
    sql_client.insert_single_row("shops", *bdt.shop())
    sql_client.insert_many_rows("photos", *bdt.photos(client))

    if not bdt.reviews() == None:
        sql_client.insert_many_rows("reviews", *bdt.reviews())


def main(DB_PATH="./db/development.sqlite3", is_replace_db=True):
    logger = get_logger(__name__, handler_level="DEBUG")
    sql_client = SQLClient(DB_PATH)
    if is_replace_db:
        sql_client.delete_all_data(tables=["shops", "addresses", "reviews"])
        logger.info("delete all tables data.")

    client = googlemaps.Client(get_api_key())  # インスタンス生成

    next_page_token = None
    shop_id = 1
    while True:
        logger.info(f"insert start. shop_id: {shop_id}")

        place_result = client.places_nearby(
            location=get_search_center(client),
            radius=200000,
            type="food",
            language="ja",
            keyword="らーめん",
            page_token=next_page_token,
        )

        if place_result["status"] != "OK":
            break

        for result in place_result["results"]:
            place_details = client.place(place_id=result["place_id"], language="ja")

            insert_data_to_db(client, shop_id, sql_client, place_details)
            shop_id += 1

        if not "next_page_token" in place_result:
            break
        next_page_token = place_result[


if __name__ == "__main__":
    main()
