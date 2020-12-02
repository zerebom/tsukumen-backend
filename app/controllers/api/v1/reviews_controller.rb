
module Api
    module V1
        class ReviewsController < ApplicationController
            def index
                review = Review.all
                render json:review
            end

            def show
                @review = Review.find(params[:id])
                render json: { status: 'SUCCESS', message: 'Loaded the review', data: @review }
            end
        end
    end
end
