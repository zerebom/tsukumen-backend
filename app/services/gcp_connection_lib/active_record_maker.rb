require 'net/http'
require 'net/https'
require 'uri'
require 'json'

def get_result(url:,
               key: 'results')
  uri = URI.parse(url)
  result = Net::HTTP.get_response(uri)
  JSON.parse(result.body)[key]
end

def make_shop(name:,
              phone_number:,
              email:,
              place_id:)
  shop = Shop.new
  shop.name = name
  shop.phone_number = phone_number
  shop.email = email
  shop.place_id = place_id
  shop
end

def make_address(shop_id:,
                 latitude:,
                 longitude:,
                 postal_code:,
                 administrative_area_level_1:,
                 county:,
                 sublocality:,
                 premise:)
  address = Address.new
  address.shop_id = shop_id
  address.latitude = latitude
  address.longitude = longitude
  address.postalcode = postal_code
  address.prefecture = administrative_area_level_1
  address.county = county
  address.locality = locality
  address.thoroughfare = sublocality
  address.sub_thoroughfare = premise
  address
end
