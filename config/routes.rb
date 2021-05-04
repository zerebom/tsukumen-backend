# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      get '/shops/near' => 'shops#sort_by_near'
      resources :shops do
        resources :reviews
        resources :addresses
        resources :photos
      end
    end
  end
end
