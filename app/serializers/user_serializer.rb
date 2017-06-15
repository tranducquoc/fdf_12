class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :authentication_token, :created_at, :updated_at
end
