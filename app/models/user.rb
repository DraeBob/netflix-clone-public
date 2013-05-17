class User < ActiveRecord::Base
  has_secure_password
  has_many :reviews

  has_many :queue_videos
  has_many :my_queued_videos, through: :queue_videos, source: :video
  # http://guides.rubyonrails.org/association_basics.html#has_many-association-reference
  
  validates :fullname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}

  def push_my_queued_videos(video)
    my_queued_videos << video
  end

  def delete_my_queued_videos(video)
    my_queued_videos.delete(video)
  end
end