class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :inviter, class_name: 'User'
  validates_presence_of :friend_name, :message, :inviter_id
  validates :friend_email,  presence: true, format: { with: /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i }
end