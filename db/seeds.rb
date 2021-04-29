# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Dir.glob(File.join(File.dirname(__FILE__), '../app/services/**/*.rb')).each { |f| require f }

# サンプルとなるデータを格納する関数
def seed_maker
  url = nearbysearch_url_maker(keyword: 'meat')
  neigbor_results = get_result(url: url, key: 'results')

  neigbor_results.each do |neigbor_result|
    place_id = neigbor_result['place_id']
    fields = 'name,rating,address_component,formatted_phone_number,geometry,reviews'
    url = find_url_maker(place_id: place_id, fields: fields)
    detail_result = get_result(url: url, key: 'result')

    shop = Shop.create
    shop = shop.from_result(detail_result, place_id)
    shop.save

    address = shop.create_address
    address = address.from_result(detail_result)
    address.save

    detail_result['reviews'].each do |review_data|
      review = shop.reviews.create
      review = review.from_result(review_data)
      review.save
    end
  end
end

seed_maker
