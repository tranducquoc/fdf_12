class Post < ApplicationRecord
  before_save :send_notification
  after_create :send_notification_to_admin

  has_many :reports
  has_many :reviews, as: :reviewable
  has_many :comments, as: :commentable
  has_many :images, through: :post_images
  has_many :post_images

  accepts_nested_attributes_for :images, allow_destroy: true

  belongs_to :user
  belongs_to :domain
  belongs_to :category, optional: true

  enum mode: {sale: 0, buy: 1}
  enum arena: {professed: 0, secret: 1}
  enum status: {pending: 0, approved: 1, rejected: 2, blocked: 3}

  validates :title, presence: true,
    length: {maximum: Settings.post.max_title, minimum: Settings.post.min_title}
  validates :content, presence: true
  validates :user, presence: true
  validates :category, presence: true
  validates :arena, presence: true
  validates :mode, presence: true
  validates :min_price, numericality: {
    greater_than_or_equal_to: Settings.post.price.min_vnd,
    less_than_or_equal_to: Settings.post.price.max_vnd
  }
  validates :max_price, numericality: {
    greater_than_or_equal_to: Settings.post.price.min_vnd,
    less_than_or_equal_to: Settings.post.price.max_vnd
  }

  scope :filtered_by_mode_time_category, (lambda do |mode, time, id|
    joins(:category).where("categories.parent_id": id, mode: mode).approved
      .order created_at: time
  end)
  scope :by_domain, (lambda do |domain_id|
    where(domain_id: domain_id).or(where domain_id: nil)
  end)
  scope :desc, ->{order created_at: :desc}

  delegate :name, :position, :avatar, :id, to: :user, prefix: true
  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :name, :slug, to: :domain, prefix: true, allow_nil: true

  private

  def send_notification
    if self.status_changed?
      Event.create message: self.status, user_id: user_id,
        eventable_id: self.id, eventable_type: Post.name
    end
  end

  def send_notification_to_admin
    Event.create message: :new_post, user_id: Admin.first.id,
      eventable_id: self.id, eventable_type: Post.name + "." + Admin.name
  end
end
