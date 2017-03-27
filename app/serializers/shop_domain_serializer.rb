class ShopDomainSerializer < ActiveModel::Serializer
  attributes :domain_id, :shop_id, :status
  belongs_to :shop

  class ShopSerializer < ActiveModel::Serializer
    attributes :name, :description, :status, :avatar, :owner_id
  end
end
