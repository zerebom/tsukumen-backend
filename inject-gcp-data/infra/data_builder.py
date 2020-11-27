from datetime import date, datetime, timedelta

class BuildDBData:
    '''
    GoogleAPIをSQLに格納できる形に変換するクラス
    '''

    def __init__(self,place_dic:dict,shop_id=0,return_sql_format=False):
        self.place_dic = place_dic
        self.shop_id = shop_id
        self.return_sql_format = return_sql_format

    def shop(self):
        return_dic = {}
        return_dic['name'] = self.place_dic['name']
        return_dic['shop_id'] = self.shop_id

        return_dic['phone_number'] = self.place_dic['formatted_phone_number'] if 'formatted_phone_number' in self.place_dic else None

        return_dic = self._add_timedate(return_dic)
        if self.return_sql_format:
            return self._dict_to_sql_format(return_dic)

        return return_dic

    def reviews(self):
        return_dic_list = []
        if 'reviews' not in self.place_dic:
            return None

        reviews = self.place_dic['reviews']

        name_corespondence = {'author_name':'reviewer',
                              'text':'review_text',
                              'rating':'star'}

        for review in reviews:
            if not 'language' in review:
                continue

            if review['language'] != 'ja':
                continue

            return_dic = {}
            for gcp_name, db_name in name_corespondence.items():
                    return_dic[db_name] = review[gcp_name]
                    return_dic['shop_id'] = self.shop_id
                    return_dic = self._add_timedate(return_dic)

            return_dic_list.append(return_dic)

        if self.return_sql_format:
            return self._dict_list_to_sql_format(return_dic_list)

        return return_dic_list

    def address(self):
        return_dic = {}

        return_dic['shop_id'] = self.shop_id
        adrs = self.place_dic['address_components']
        loc = self.place_dic['geometry']['location']

        return_dic['latitude'] = loc['lat']
        return_dic['longitude'] = loc['lng']
        return_dic = self._add_address_data(return_dic,adrs)
        return_dic = self._add_timedate(return_dic)

        if self.return_sql_format:
            return self._dict_to_sql_format(return_dic)

        return return_dic


    def _add_timedate(self,dic):
        time = datetime.now()
        dic['created_at'] = time
        dic['updated_at'] = time
        return dic

    def _add_address_data(self,dic,adrs):
        #gcp_name:db_nameの対応表
        name_corespondence = {'postal_code':'postalcode',
                              'administrative_area_level_1':'prefecture',
                              'locality':'locality',
                              'sublocality':'thoroughfare',
                              'premise':"sub_thoroughfare"}

        for val in adrs:
            for gcp_name, db_name in name_corespondence.items():
                if gcp_name in val['types']:
                    dic[db_name] = val['short_name']

        return dic

    def _dict_to_sql_format(self,dic):
        return list(dic.keys()), list(dic.values())

    def _dict_list_to_sql_format(self,dic_list):
        keys = list(dic_list[0].keys())
        vals = []
        for dic in dic_list:
            vals.append(list(dic.values()))

        return keys, vals
