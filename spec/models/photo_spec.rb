require 'rails_helper'

RSpec.describe Photo, type: :model do
  let(:place_id) do
    url = nearbysearch_url_maker(keyword: 'meat')
    results = request_result(url: url, key: 'results')
    results[0]['place_id']
  end
  let(:result) do
    fields = 'name,formatted_phone_number,photo,opening_hours/weekday_text'
    url = find_url_maker(place_id: place_id, fields: fields)
    request_result(url: url, key: 'result')
  end
  let(:shop) do
    shop = Shop.new
    shop.from_result(result,
                     place_id)
  end
  it 'indicate that photo can be generated from request.' do
    photo = shop.photos.build
    idx = 0
    photo_ref = result['photos'][idx]['photo_reference']
    photo = photo.photo_ref_to_save(photo_ref, shop.place_id, idx)
    expect(photo.valid?).to eq true
  end
end
