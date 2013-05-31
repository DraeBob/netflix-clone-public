class User < ActiveRecord::Base
  has_secure_password
  has_many :reviews
  has_many :queue_videos, order: :position
  has_many :followerships
  has_many :followers, through: :followerships
 
  validates :fullname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
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
end