class Post < ApplicationRecord

  has_many :reports
  has_many :reviews, as: :reviewable
  has_many :comments, as: :commentable

  belongs_to :user
  belongs_to :category, optional: true

  enum type: {sale: 0, buy: 1}

  validates :title, presence: true,
    length: {maximum: Settings.post.max_title, minimum: Settings.post.min_title}
  validates :content, presence: true

  delegate :name, :position, :avatar, to: :user, prefix: true

  delegate :name, to: :category, prefix: true, allow_nil: true

end
