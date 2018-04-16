class Report < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true

  delegate :name, :id, to: :user, prefix: true
  delegate :title, to: :post, prefix: true
end
