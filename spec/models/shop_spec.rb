require 'rails_helper'

RSpec.describe Shop, type: :model do
  let(:shop) do
    url = nearbysearch_url_maker(keyword: 'meat')
    results = get_result(url: url, key: 'results')
    place_id = results[0]['place_id']

    fields = 'name,rating,formatted_phone_number,opening_hours/weekday_text'
    url = find_url_maker(place_id: place_id, fields: fields)
    result = get_result(url: url, key: 'result')

    shop = Shop.new
    shop.from_result(result, place_id)
  end

  subject { shop.valid? }
  it 'indicate that Shop can be generated from cls method.' do
    is_expected.to eq true
  end
end
