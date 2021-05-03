require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:place_id) do
    url = nearbysearch_url_maker(keyword: 'meat')
    results = get_result(url: url, key: 'results')
    results[0]['place_id']
  end
  let(:result) do
    fields = 'name,rating,address_component,formatted_phone_number,geometry,reviews'
    url = find_url_maker(place_id: place_id, fields: fields)
    get_result(url: url, key: 'result')
  end
  let(:shop) do
    shop = Shop.new
    shop.from_result(result, place_id)
  end
  it 'indicate that Address can be generated from request.' do
    review = shop.reviews.build
    review.from_result(result['reviews'][0])
    puts review.inspect
    expect(review.valid?).to eq true
  end
end
