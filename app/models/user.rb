class User < ActiveRecord::Base
  include Tokenable

  has_secure_password
  has_many :reviews, order: "created_at desc"
  has_many :queue_videos, order: :position

  has_many :following_relationships, class_name: "Followership", foreign_key: "follower_id"
  has_many :followed_relationships, class_name: "Followership", foreign_key: "followee_id"
 
  has_many :invitations, class_name: "invitation", foreign_key: 'inviter_id'

  validates :fullname, presence: true, uniqueness: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i }
  validates :password, presence: true, length: {minimum: 6}

  def normalize_queue_item_positions 
    queue_videos.each_with_index do |queue_video, index|
      queue_video.update_attributes(position: index + 1)
    end
  end

  def rate_queue_videos
    queue_videos.each_with_index do |queue_video, rate|
      queue_video.update_attributes(rate: rate)
    end
  end

  def queued_already?(video)
    queue_videos.collect(&:video).include?(video)
  end

  def follows?(a_followee)
    following_relationships.map(&:followee).include?(a_followee)
  end

  def can_follow?(a_followee)
    !(self.follows?(a_followee) || self == a_followee)
  end

end