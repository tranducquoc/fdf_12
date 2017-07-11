class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :authentication_token,
    :address, :chatwork_id, :description, :status, :created_at, :updated_at
end
