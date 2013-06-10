class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'
  has_one :friend, class_name: 'User'

  validates_presence_of :friend_email, :friend_name, :message
  validate :friend_is_not_registered 

  before_create :generate_token

  def friend_is_not_registered
    errors.add :friend_email, 'is already registered' if User.find_by_email(friend_email)
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end