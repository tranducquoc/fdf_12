class Category < ApplicationRecord
  strip_attributes only: :name

  acts_as_paranoid

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  has_many :products
  has_many :posts
  has_many :subcategories, class_name: Category.name, foreign_key: :parent_id

  belongs_to :parent_category, class_name: Category.name,
    foreign_key: :parent_id

  scope :asc_by_name, ->{order :name}
  scope :is_parent, ->{where parent_id: 0}
  scope :by_parent, -> parent_id{where parent_id: parent_id}
  scope :parent_category, -> id{where id: id}

  validates :name, presence: true, uniqueness: true

  def slug_candidates
    [:name, [:name, :id]]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed? || super
  end

  def subcategories_posts
    posts ||= 0
    subcategories.includes(:posts).each do |category|
      posts += category.posts.size
    end
    return posts unless posts > Settings.category.max_posts
    "#{Settings.category.max_posts}+"
  end

  class << self
    def number_category_by_domain category, domain
      domain.products.by_category(category).size
    end
  end
end
