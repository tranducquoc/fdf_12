class Review < ApplicationRecord
  acts_as_paranoid
  ratyrate_rateable 'rating'

  belongs_to :user
  belongs_to :reviewable, polymorphic: true

  delegate :name, :avatar, to: :user, prefix: true

  scope :reviews_by_post, -> type, id {where reviewable_id: id, reviewable_type: type}

  scope :newest, -> {order created_at: :desc}

  validates :review, presence: true
end
