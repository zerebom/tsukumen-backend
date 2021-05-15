require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'nokogiri'

API_KEY = File.open('./GCP_API_KEY').read

def nearbysearch_url_maker(lat: -33.8670522,
                           lon: 151.1957362,
                           radius: 3000,
                           type: 'restaurant',
                           keyword: 'meat')

  default_url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
  puts default_url
  url = "#{default_url}location=#{lat},#{lon}&radius=#{radius}&type=#{type}&keyword=#{keyword}&key=#{API_KEY}&language=ja"
  URI.encode(url)
end

def find_url_maker(place_id:,
                   fields: 'name,rating,formatted_phone_number,geometry')

  default_url = 'https://maps.googleapis.com/maps/api/place/details/json?'
  url = "#{default_url}place_id=#{place_id}&fields=#{fields}&key=#{API_KEY}&language=ja"
  URI.encode(url)
end

def photo_url_maker(photo_ref, w_and_h)
  default_url = 'https://maps.googleapis.com/maps/api/place/photo?'
  url = "#{default_url}maxwidth=#{w_and_h}&maxheight=#{w_and_h}&photoreference=#{photo_ref}&key=#{API_KEY}&language=ja"
  URI.encode(url)
end

def request_result(url:,
                   key: 'results')
  uri = URI.parse(url)
  result = Net::HTTP.get_response(uri)
  JSON.parse(result.body)[key]
end

def request_photo(url)
  uri = URI.parse(url)
  result = Net::HTTP.get_response(uri)

  # If url was removed, try to access another url.
  if result.code == '302'
    doc = Nokogiri::HTML.parse(result.body)
    new_ref = doc.css('a')[0][:href]
    puts new_ref
    new_uri = URI.parse(new_ref)
    Net::HTTP.get_response(new_uri).body
  else
    result.body
  end
end
