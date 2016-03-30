# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  # The scope part validates that the body is unique per post. The same body
  # however may be used for multiple posts
  validates :body, presence: true, uniqueness: {scope: :post_id}

  def user_full_name
    user.full_name if user
  end
end
