class User < ActiveRecord::Base
  has_secure_password
  has_many :reviews, order: "created_at desc"
  has_many :queue_videos, order: :position

  has_many :following_relationships, class_name: "Followership", foreign_key: "follower_id"
  has_many :followed_relationships, class_name: "Followership", foreign_key: "followee_id"
 
  validates :fullname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}

  before_create :generate_token

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

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

end