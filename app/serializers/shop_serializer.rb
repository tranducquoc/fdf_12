class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :status, :avatar, :averate_rating,
    :owner_id, :owner_name, :owner_email, :owner_avatar
end
