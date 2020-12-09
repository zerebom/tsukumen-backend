
module Api
    module V1
        class ReviewsController < ApplicationController
            def index
                shop = Shop.find(params[:shop_id])
                reviews = shop.reviews.all
                render json:{ status: 'SUCCESS', message: 'Loaded the reviews', data: reviews }
            end

            def show
                all_reviews = Shop.find(params[:shop_id]).reviews

                review_id = params[:id].to_i
                # 0-index->1-index
                review = all_reviews[review_id-1]
                render json: { status: 'SUCCESS', message: 'Loaded the review', data:review}
            end
        end
    end
end
