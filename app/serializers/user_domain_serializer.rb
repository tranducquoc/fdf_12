class UserDomainSerializer < ActiveModel::Serializer
  attributes :domain_id
  belongs_to :domain
end
