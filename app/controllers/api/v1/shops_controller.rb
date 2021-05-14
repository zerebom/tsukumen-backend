# frozen_string_literal: true

require_relative('../../../../db/seeds')

module Api
  module V1
    class ShopsController < ApplicationController
      def index
        shop = Shop.all
        render json: shop
      end

      def get_near_data_from_db(latitude, longitude, limit)
        @address = Address.all
        @address = @address.order_location_by(
          latitude, longitude
        )
        @address = @address.includes(:shop).limit(limit)
        @shops = @address.map { |adrs| adrs.shop }
        @shops
      end

      def get_near_data_from_gcp(latitude, longitude, limit)
        seed_maker = SeedMaker.new(keyword: 'ラーメン',
                                   save_photo: false,
                                   limit: limit,
                                   latitude: latitude,
                                   longitude: longitude)
        @shops = seed_maker.run
        @shops
      end

      def sort_by_near
        latitude = params[:latitude]
        longitude = params[:longitude]
        limit = params[:limit]

        round_lat = latitude.to_f.round(3)
        round_lon = longitude.to_f.round(3)
        @lat_lon = LatLon.find_by(latitude: round_lat, longitude: round_lon)

        @shops = if @lat_lon.nil?
                   get_near_data_from_gcp(latitude, longitude, limit)
                 else
                   get_near_data_from_db(latitude, longitude, limit)
                 end

        render json: { status: 'SUCCESS', message: 'Loaded the shop sort by distance', data: @shops }
      end

      def show
        @shop = Shop.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded the shop', data: @shop }
      end
    end
  end
end
