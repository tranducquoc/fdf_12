class UserDomainSerializer < ActiveModel::Serializer
  :domain_id
  belongs_to :domain
end
