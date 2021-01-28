def path_to_photo(place_id,idx)
    filename = idx.to_s.rjust(3,"0") + ".png"
    image = File.read(Rails.root.join('app','assets','images',place_id,filename))
    return image
end

def image_to_base64(image)
    b64_image = Base64.strict_encode64(image)
    return b64_image
end

module Api
    module V1
        class PhotosController < ApplicationController
            def index

                shop = Shop.find(params[:shop_id])
                photos = shop.photos.all
                render json:{ status: 'SUCCESS', message: 'Loaded the photo', data: photos }
            end

            def show
                all_photos = Shop.find(params[:shop_id]).photos
                place_id = Shop.find(params[:shop_id]).place_id

                photo_id = params[:id].to_i

                photo = all_photos[photo_id-1]
                image = path_to_photo(place_id, photo_id)
                b64_image = image_to_base64(image)

                render json: { status: 'SUCCESS', message: 'Loaded the photo', data:photo, base64:b64_image}
            end
        end
    end
end


