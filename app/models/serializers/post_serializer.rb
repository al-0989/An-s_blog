class PostSerializer < ActiveModel::Serializer
  # these are the attributes that the serializer will pass
  attributes :id, :title, :body
end
