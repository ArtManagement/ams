class Image < ApplicationRecord
  belongs_to :artwork
  accepts_nested_attributes_for :artwork
  mount_uploader :image1, ImageUploader
  mount_uploader :image2, ImageUploader
  mount_uploader :image3, ImageUploader
  mount_uploader :image4, ImageUploader
end
