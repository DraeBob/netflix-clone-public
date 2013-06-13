class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :inviter, class_name: 'User'
  
  validates_presence_of :friend_email, :friend_name, :message, :inviter_id
  validate :friend_is_not_registered 

  def friend_is_not_registered
    errors.add :friend_email, 'is already registered' if User.find_by_email(friend_email)
  end

end