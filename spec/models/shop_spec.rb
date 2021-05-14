require 'rails_helper'

RSpec.describe Shop, type: :model do
  latitude = 35.61
  longitude = 139.65

  let(:lat_lon) do
    LatLon.new(latitude: latitude, longitude: longitude)
  end

  let(:shop) do
    url = nearbysearch_url_maker(keyword: 'meat',
                                 lat: latitude,
                                 lon: longitude)
    results = request_result(url: url, key: 'results')
    place_id = results[0]['place_id']

    fields = 'name,rating,formatted_phone_number,opening_hours/weekday_text'
    url = find_url_maker(place_id: place_id, fields: fields)
    result = request_result(url: url, key: 'result')

    shop = lat_lon.shops.build
    shop.from_result(result, place_id)
  end

  # TODO: lat_lonをrelationに追加したので、落ちる
  subject { shop.valid? }
  it 'indicate that Shop can be generated from cls method.' do
    is_expected.to eq true
  end
end
