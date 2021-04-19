# frozen_string_literal: true

API_KEY = 'AIzaSyBF3-g28urAlQQDUDP8kdYbu5CJVQ44Ue0'

def nearbysearch_url_maker(loc: -33.8670522,
                           lat: 151.1957362,
                           radius: 15_000,
                           type: 'restaurant',
                           keyword: 'meat')

  default_url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
  url = "#{default_url}location=#{loc},#{lat}&radius=#{radius}&type=#{type}&keyword=#{keyword}&key=#{API_KEY}"
  URI.encode(url)
end

def find_url_maker(place_id:)
  fields = 'name,rating,formatted_phone_number'
  default_url = 'https://maps.googleapis.com/maps/api/place/details/json?'
  url = "#{default_url}place_id=#{place_id}&fields=#{fields}&key=#{API_KEY}"
    URI.encode(url)
end

def get_result(url:,
               key: 'results')
  uri = URI.parse(url)
  result = Net::HTTP.get_response(uri)
  puts result.body
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

class Test
  require 'net/http'
  require 'net/https'
  require 'uri'
  require 'json'

  def test
    url = nearbysearch_url_maker
    results = get_result(url: url, key: 'results')
    place_id = results[0]['place_id']
    puts place_id

    url = find_url_maker(place_id: place_id)
    puts url
    result = get_result(url: url, key: 'result')

    make_shop(name: result['name'],
              phone_number: result['formatted_phone_number'],
              email: result['email'],
              place_id: place_id)

    puts 'res:'
    puts result
    puts ':res'
  end
end

t = Test.new
t.test
