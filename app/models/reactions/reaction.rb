class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactionable, polymorphic: true

  validates :user, presence: true
  validates :reactionable, presence: true
end
