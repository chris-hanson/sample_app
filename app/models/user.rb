class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  has_secure_password

  before_save { |user| user.email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.\_\+]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,     presence: true, length: { maximum: 50 }
  validates :email,    presence: true, 
                         format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates :password_confirmation, presence: true, length: { minimum: 6 }
end
