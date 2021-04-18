# %%
from utils import cal_distance

import math
import pandas as pd
import subprocess
import pprint  # list型やdict型を見やすくprintするライブラリ
import googlemaps
import os
from PIL import Image, ImageOps
from io import BytesIO
import sys


# %%
with open('../GCP_API_KEY', 'r') as f:
    API_KEY = f.read()

# %%

client = googlemaps.Client(API_KEY)  # インスタンス生成
component = {''}
geocode_result = client.geocode('つくば市')  # 位置情報を検索
loc = geocode_result[0]['geometry']['location']  # 軽度・緯度の情報のみ取り出す

# %%
place_result = client.find_place(
    location_bias='circle:2000:@36.0835255,140.0764454',
    input_type='textquery',
    input='ラーメン',
    fields=['name', 'rating', 'photos'],
    language='ja',
)

place_result

# %%
# 半径5kmのラーメン屋を収集
place_result = client.places_nearby(
    location=loc,
    radius=5000,
    type='food',
    language='ja',
    keyword='ラーメン')


# %%
cal_distance()


# %%
# place_resultの中身
#dict_keys(['html_attributions', 'next_page_token', 'results', 'status'])
# print(place_result.keys())

# 20
# print(len(place_result['results']))

# 20 件移行を取得したいならclientにnext_page_tokenを渡す
# next_page_token = place_result['next_page_token']


# %%
# 各店舗のレビューを取得するにはplaces_nearbyを使って取得したplace_idをplaceAPIに投げる
place_id = place_result['results'][0]['place_id']
place_details = client.place(
    place_id='ChIJ_wXNP1ypGGARZBldsBUqe-A', language='ja')


# out: dict_keys(['html_attributions', 'result', 'status'])
print(place_details.keys())

# out:
# dict_keys(['address_components', 'adr_address', 'business_status', 'formatted_address', 'formatted_phone_number', 'geometry', 'icon', 'international_phone_number', 'name', 'opening_hours', 'photos', 'place_id', 'plus_code', 'price_level', 'rating', 'reference', 'reviews', 'types', 'url', 'user_ratings_total', 'utc_offset', 'vicinity'])
print(place_details['result'].keys())


# %%
print(place_details['result']['reviews'][0].keys())

# dict_keys(['author_name', 'author_url', 'language', 'profile_photo_url', 'rating', 'relative_time_description', 'text', 'time'])

# レビュー取得
print(place_details['result']['reviews'])


# %%
photo_ref = place_details['result']['photos'][0]['photo_reference']
photo = client.places_photo(photo_ref, max_width=300)

# %%

# 画像保存
local_filename = 'photo.txt'
f = open(local_filename, 'wb')
for chunk in client.places_photo(photo_ref, max_width=100):
    if chunk:
        f.write(chunk)
f.close()

# %%

# 画像確認
img = Image.open('photo.txt')
img
