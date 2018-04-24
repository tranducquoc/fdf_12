class Post < ApplicationRecord
  has_many :reports
  has_many :reviews, as: :reviewable
  has_many :comments, as: :commentable
  has_many :images, through: :post_images
  has_many :post_images

  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true

  belongs_to :user
  belongs_to :category, optional: true

  enum mode: {sale: 0, buy: 1}
  enum arena: {professed: 0, secret: 1}

  validates :title, presence: true,
    length: {maximum: Settings.post.max_title, minimum: Settings.post.min_title}
  validates :content, presence: true

  scope :filtered_by_mode_time_category, ->(mode, time, id){joins(:category)
    .where("categories.parent_id": id, mode: mode).order created_at: time}

  delegate :name, :position, :avatar, to: :user, prefix: true
  delegate :name, to: :category, prefix: true, allow_nil: true
end
