class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :inviter, class_name: 'User'
  validates_presence_of :friend_name, :message, :inviter_id
  validates :friend_email,  presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i  }
end