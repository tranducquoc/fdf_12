class Review < ApplicationRecord
  after_create :send_notification_to_post_owner

  acts_as_paranoid
  ratyrate_rateable 'rating'

  has_many :likes, as: :reactionable

  belongs_to :user
  belongs_to :reviewable, polymorphic: true

  delegate :name, :avatar, to: :user, prefix: true

  scope :reviews_by_post, -> type, id {where reviewable_id: id, reviewable_type: type}
  scope :newest, -> {order created_at: :desc}

  validates :review, presence: true

  def like_by? user
    return true if Reaction.find_by user_id: user.id, reactionable_id: id
    false
  end

  private
  def send_notification_to_post_owner
    Event.create message: I18n.t(".review_message", sender: user.name,
      title: self.reviewable.title),
      user_id: self.reviewable.user_id,
      eventable_id: self.id, eventable_type: Review.name
  end
end
