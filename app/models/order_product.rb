class OrderProduct < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :order
  belongs_to :product
  belongs_to :coupon

  enum status: {pending: 0, accepted: 1, rejected: 2, done: 3}
  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :product, prefix: true

  def total_price
    product.price * quantity
  end

  scope :by_user, -> user {where user: user}
  scope :group_product, -> do
    joins(:product)
      .select("order_products.product_id, sum(order_products.quantity) as total")
      .group("order_products.product_id")
      .order("total DESC")
  end
end
