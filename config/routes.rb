Rails.application.routes.draw do
  namespace 'api' do
      namespace 'v1' do
        resources :shops do
          resources :reviews
          resources :addresses
      end
    end
  end
end