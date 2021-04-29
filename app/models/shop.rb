# frozen_string_literal: true

class Shop < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_one :address

  validates :place_id, presence: true

  def from_result(result:, place_id:)
    self.name = result['name']
    self.phone_number = result['formatted_phone_number']
    self.email = result['email']
    self.place_id = place_id
    self
  end
end

#   # ref: https://qiita.com/suzuki-koya/items/1553c405beeb73f83bbc
#   def self.from_result(result:,
#                        place_id:)
#     shop = self.new
#     shop.name = result['name']
#     shop.phone_number = result['formatted_phone_number']
#     shop.email = result['email']
#     shop.place_id = place_id
#     shop
#   end
# end
