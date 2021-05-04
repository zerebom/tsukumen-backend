# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Dir.glob(File.join(File.dirname(__FILE__), '../app/services/**/*.rb')).each { |f| require f }

class SeedMaker
  def initialize(keyword: 'meat',
                 save_photo: false,
                 limit: 5,
                 latitude: 35.61,
                 longitude: 139.65)
    @nearby_url = nearbysearch_url_maker(keyword: keyword)
    @neigbor_results = request_result(url: @nearby_url, key: 'results')
    @limit = limit
    @save_photo = save_photo
    @latitude = latitude
    @longitude = longitude
    self.inspect
  end

  def get_detail_result(neigbor_result)
    @pid = neigbor_result['place_id']
    fields = 'name,rating,address_component,formatted_phone_number,geometry,reviews,photo,opening_hours/weekday_text'
    url = find_url_maker(place_id: @pid, fields: fields)
    request_result(url: url, key: 'result')
  end

  def run
    @lat_lon = self.lat_lon
    shop_array = []
    @neigbor_results.each_with_index do |neigbor_result, idx|
      puts idx
      detail_result = self.get_detail_result(neigbor_result)
      @shop = self.shop(detail_result)
      self.address(detail_result)
      self.review(detail_result)
      self.photo(detail_result) if @save_photo
      shop_array.append(@shop)
      break if idx == @limit
    end
    shop_array
  end

  def lat_lon
    lat_lon = LatLon.new(latitude: @latitude, longitude: @longitude)
    lat_lon.save
    lat_lon
  end

  def shop(detail_result)
    shop = @lat_lon.shops.create
    shop.from_result(detail_result, @pid)
    shop.save
    shop
  end

  def address(detail_result)
    address = @shop.create_address
    address = address.from_result(detail_result)
    address.save
    address
  end

  def review(detail_result)
    detail_result['reviews'].each do |review_data|
      review = @shop.reviews.create
      review = review.from_result(review_data)
      review.save
    end
  end

  def photo(detail_result)
    detail_result['photos'].each_with_index do |photo_data, idx|
      photo = @shop.photos.create
      photo_ref = photo_data['photo_reference']
      photo = photo.photo_ref_to_save(photo_ref, @shop.place_id, idx)
      photo.save
      break if idx == 2
    end
  end
end

# TODO: 実行部とclass定義のfileを分ける
if __FILE__ == $PROGRAM_NAME
  seed_maker = SeedMaker.new
  seed_maker.run
end
