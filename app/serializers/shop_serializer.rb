class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :status, :avatar, :averate_rating,
    :cover_image, :owner_id, :owner_name, :owner_email, :owner_avatar
end
