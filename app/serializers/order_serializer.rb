class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :end_at, :notes, :user_id, :shop_id, :coupon_id,
    :deleted_at, :created_at, :updated_at, :total_pay, :domain_id
  has_many :order_products
end
