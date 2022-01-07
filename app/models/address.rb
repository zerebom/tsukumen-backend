# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :shop

  scope :order_location_by, lambda { |latitude, longitude|
                              sort_by_near(latitude, longitude)
                            }

  # privateなクラスメソッドを書く方法(SQLインジェクション対策)
  # ref: https://jakeyesbeck.com/2016/01/24/ruby-private-class-methods/ class << self
    private

    def sort_by_near(latitude, longitude)
      select("*, (
          6371 * acos(
              cos(radians(#{latitude}))
              * cos(radians(latitude))
              * cos(radians(longitude) - radians(#{longitude}))
              + sin(radians(#{latitude}))
              * sin(radians(latitude))
          )
          ) AS distance").order(:distance)
    end
  end


  def from_result(result)
    address_components = result['address_components']
    name_corespondence = { 'postal_code': 'postalcode',
                           'administrative_area_level_1': 'prefecture',
                           'locality': 'locality',
                           'sublocality': 'thoroughfare',
                           'premise': 'sub_thoroughfare' }
    kwargs = {}
    address_components.each do |address_val|
      name_corespondence.each do |gcp_name, db_name|
        kwargs[db_name.to_sym] = address_val['short_name'] if address_val['types'].include?(gcp_name.to_s)
      end
    end
    self.latitude = result['geometry']['location']['lat']
    self.longitude = result['geometry']['location']['lng']
    self.postalcode = kwargs[:postalcode] if kwargs.key?(:postalcode)
    self.prefecture = kwargs[:prefecture] if kwargs.key?(:prefecture)
    self.locality = kwargs[:locality] if kwargs.key?(:locality)
    self.thoroughfare = kwargs[:thoroughfare] if kwargs.key?(:thoroughfare)
    self.sub_thoroughfare = kwargs[:sub_thoroughfare] if kwargs.key?(:sub_thoroughfare)
    self
  end
end
