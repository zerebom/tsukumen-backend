# %%
from dataclasses import field
from typing import List
from datetime import datetime
from dataclasses import dataclass
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
geocode_result = client.geocode('つくば市')  # 位置情報を検索
loc = geocode_result[0]['geometry']['location']  # 軽度・緯度の情報のみ取り出す

# %%

place_result = client.places_nearby(
    location=loc,
    radius=5000,
    type='food',
    language='ja',
    keyword='ラーメン')

# %%
next_page_token = place_result['next_page_token']
results = place_result['results']


# %%
pprint.pprint(results[2]['place_id'])


# %%
place_id = results[2]['place_id']

# %%
place_detail = client.place(place_id=place_id,
                            language='ja')


# %%
pprint.pprint(place_detail)

# %%

'/'.join(place_detail['result']['opening_hours']['weekday_text'])


# %%


# %%


@dataclass
class AbsData:
    created_at: datetime = field(init=False)
    updated_at: datetime = field(init=False)

    def __post_init__(self):
        time = datetime.now()
        self.created_at = time
        self.updated_at = time


@dataclass
class Reviews(AbsData):
    id: str
    star: int
    review_text: str
    reviewer: str

    @classmethod
    def from_result(cls, result):
        d = {}
        d['id'] = result['place_id']
        d = cls._add_address_data(d, result['address_components'])
        return cls(**d)

    @staticmethod
    def _add_review_data(dic, adrs):
        pass


@dataclass
class Address(AbsData):
    id: str

    postalcode: str
    prefecture: str
    locality: str
    thoroughfare: str
    sub_thoroughfare: str

    @classmethod
    def from_result(cls, result):
        d = {}
        d['id'] = result['place_id']
        d = cls._add_address_data(d, result['address_components'])
        return cls(**d)

    @staticmethod
    def _add_address_data(dic, adrs):
        name_corespondence = {'postal_code': 'postalcode',
                              'administrative_area_level_1': 'prefecture',
                              'locality': 'locality',
                              'sublocality': 'thoroughfare',
                              'premise': "sub_thoroughfare"}

        for val in adrs:
            for gcp_name, db_name in name_corespondence.items():
                if gcp_name in val['types']:
                    dic[db_name] = val['short_name']

        return dic


@dataclass
class Place(AbsData):
    id: str
    name: str
    phone_number: str
    weekday_text: str

    @classmethod
    def from_result(cls, result):
        d = {}
        for key in ['name']:
            d[key] = result[key]

        d['id'] = result['place_id']
        d['phone_number'] = result['formatted_phone_number']
        d['weekday_text'] = '/'.join(result['opening_hours']['weekday_text'])

        return cls(**d)


p = Place.from_result(place_detail['result'])
a = Address.from_result(place_detail['result'])

pprint.pprint(p)
pprint.pprint(a)

# %%


# %%
