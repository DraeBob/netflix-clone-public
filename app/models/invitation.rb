class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :inviter, class_name: 'User'

  validates_presence_of :friend_email, :friend_name, :message, :inviter_id
end