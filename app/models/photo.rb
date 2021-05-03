# frozen_string_literal: true

require 'fileutils'

class Photo < ApplicationRecord
  belongs_to :shop

  def path_maker(place_id, idx)
    dir = Rails.root.join('app', 'assets', 'images', place_id)
    path = Rails.root.join('app', 'assets', 'images', place_id, "#{idx.to_s.rjust(3, '0')}.png")
    [dir, path]
  end

  def save_photo(photo)
    File.open(self.path, 'wb') do |f|
      f.write(photo)
    end
  end

  def mkdir(dir)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
  end

  def photo_ref_to_save(photo_ref, place_id, idx)
    url = photo_url_maker(photo_ref, 100)
    photo = request_photo(url)
    dir, self.path = path_maker(place_id, idx)

    self.mkdir(dir)
    self.save_photo(photo)
    self
  end
end
