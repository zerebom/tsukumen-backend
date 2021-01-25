class Shop < ApplicationRecord
    has_many :reviews, dependent: :destroy
    has_many :photos, dependent: :destroy
    has_one :address
end
