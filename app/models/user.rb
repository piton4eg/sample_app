class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy

	has_secure_password
  before_save { email.downcase! }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates :password_confirmation, presence: true
  validates :password, length: { minimum: 6 }
  validates_confirmation_of :password

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  private
	  def create_remember_token
	  	self.remember_token = SecureRandom.urlsafe_base64  	
	  end
end
 