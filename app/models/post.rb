class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  # create a friendly id out of the title
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_user, through: :favorites, source: :user


  validates :title, presence: true, uniqueness: true, length: {minimum: 7}
  validates :body, presence: true

  def self.search(str)
    where(["title ILIKE ? OR body ILIKE ?", "%#{str}%", "%#{str}%"])
  end

  def body_snippet(body)
    if body.length > 100
      snippet = body.truncate(100)
    else
      snippet = body
    end
  end

  def category_name
    category.name if category
  end

  def user_full_name
    user.full_name if user
  end

  def favorite_for(user)
    # find the favorite associated with the current user. For use in the show page
    favorites.find_by_user_id(user)
  end

end
