class User < ActiveRecord::Base
  # This is a built in method that is available to us via the bcrypt gem
  # In order for it to work the users model must have field called password_digest
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post 
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true,
            format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def full_name
    "#{first_name} #{last_name}".titleize
  end
end
