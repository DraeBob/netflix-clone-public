class User < ActiveRecord::Base
  has_secure_password
  has_many :reviews
  has_many :queue_videos, order: :position
 
  validates :fullname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}

  def reorder_queue_videos 
    queue_videos.each_with_index do |queue_video, index|
      queue_video.update_attributes(position: index + 1)
    end
  end
end