require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:place_id) do
    url = nearbysearch_url_maker(keyword: 'meat')
    results = request_result(url: url, key: 'results')
    results[0]['place_id']
  end
  let(:result) do
    fields = 'name,rating,address_component,formatted_phone_number,geometry,opening_hours/weekday_text'
    url = find_url_maker(place_id: place_id, fields: fields)
    request_result(url: url, key: 'result')
  end
  let(:shop) do
    shop = Shop.new
    shop.from_result(result,
                     place_id)
  end
  it 'indicate that Address can be generated from request.' do
    address = shop.build_address
    address.from_result(result)

    expect(address.valid?).to eq true
  end
end
