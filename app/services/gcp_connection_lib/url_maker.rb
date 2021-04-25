require 'net/http'
require 'net/https'
require 'uri'
require 'json'

API_KEY = File.open('./GCP_API_KEY').read

def nearbysearch_url_maker(loc: -33.8670522,
                           lat: 151.1957362,
                           radius: 15_000,
                           type: 'restaurant',
                           keyword: 'meat')

  default_url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
  url = "#{default_url}location=#{loc},#{lat}&radius=#{radius}&type=#{type}&keyword=#{keyword}&key=#{API_KEY}"
  URI.encode(url)
end

def find_url_maker(place_id:,
                   fields: 'name,rating,formatted_phone_number,geometry')

  default_url = 'https://maps.googleapis.com/maps/api/place/details/json?'
  url = "#{default_url}place_id=#{place_id}&fields=#{fields}&key=#{API_KEY}"
  URI.encode(url)
end
