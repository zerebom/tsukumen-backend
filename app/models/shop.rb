# frozen_string_literal: true

class Shop < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_one :address

  validates :place_id, presence: true

  def from_result(result, place_id)
    self.name = result['name']
    self.phone_number = result['formatted_phone_number']
    self.email = result['email']
    self.place_id = place_id
    self.opening_hours = result['opening_hours']['weekday_text'].join(',') if result.key?('opening_hours')
    self
  end
end
