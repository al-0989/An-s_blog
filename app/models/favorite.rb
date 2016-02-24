class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :user_id, :post_id, uniqueness: true
  validates :user_id, uniqueness: {scope: :post_id}
end
