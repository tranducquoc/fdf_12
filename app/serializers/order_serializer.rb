class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :end_at, :notes, :user_id, :user_name, :shop_id, :coupon_id,
    :deleted_at, :created_at, :updated_at, :total_pay, :domain_id
  has_many :order_products

  class OrderProductSerializer < ActiveModel::Serializer
    attributes :id, :quantity, :price, :notes, :user_id, :order_id, :product_id,
      :product_name, :product_price, :product_image, :coupon_id, :deleted_at,
      :updated_at, :status
  end
end
