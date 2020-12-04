
module Api
    module V1
        class AddressesController < ApplicationController

            def index
                shop = Shop.find(params[:shop_id])
                 address = shop.address
                render json:{ status: 'SUCCESS', message: 'Loaded the addresses', data:  address}
            end

        end
    end
end
