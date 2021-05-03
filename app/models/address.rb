# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :shop
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
