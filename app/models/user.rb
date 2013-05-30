class User < ActiveRecord::Base
	has_secure_password
  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates :password_confirmation, presence: true
  validates :password, length: { minimum: 6 }
  validates_confirmation_of :password
end
 