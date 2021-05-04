# frozen_string_literal: true

module Api
  module V1
    class ShopsController < ApplicationController
      def index
        shop = Shop.all
        render json: shop
      end

      def sort_by_near
        latitude = params[:latitude]
        longitude = params[:longitude]
        @address = Address.all
        @address = @address.order_location_by(
          latitude, longitude
        )
        @address = @address.includes(:shop).limit(params[:limit])
        @shop = @address.map { |adrs| adrs.shop }
        render json: { status: 'SUCCESS', message: 'Loaded the shop sort by distance', data: @shop }
      end

      def show
        @shop = Shop.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded the shop', data: @shop }
      end
    end
  end
end
