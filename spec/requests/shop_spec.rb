require 'rails_helper'

RSpec.describe 'Shops', type: :request do
  describe 'GET #sort_by_near' do
    it 'responds successfully' do
      get '/api/v1/shops/near?latitude=40&longitude=40&distance=4000'
      expect(response).to be_success
    end
  end
end
