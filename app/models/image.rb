class Image < ApplicationRecord
  has_many :posts, through: :post_images
  has_many :post_images

  mount_uploader :image, PostImageUploader
end
