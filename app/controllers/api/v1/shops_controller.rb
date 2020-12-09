module Api
    module V1
        class ShopsController < ApplicationController
            def index
                shop = Shop.all
                render json: shop
            end

            def show
                @shop = Shop.find(params[:id])
                render json: { status: 'SUCCESS', message: 'Loaded the shop', data: @shop }
            end
        end
    end
end