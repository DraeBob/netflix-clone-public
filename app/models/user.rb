class User < ActiveRecord::Base
  has_secure_password
  has_many :reviews

  validates :fullname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}
end