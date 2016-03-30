class CommentSerializer < ActiveModel::Serializer
  
  attributes :id, :body, :creation_date

  def creation_date
    object.created_at.strftime("%Y-%b-%d")
  end

end
