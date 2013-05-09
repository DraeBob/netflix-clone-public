class Category < ActiveRecord::Base

  has_many :video_categories
  has_many :videos, through: :video_categories

  validates :name, presence: true

  def recent_videos
    videos = Video.find(:all, order: "created_at desc", limit: 6)
    #videos = Video.order("created_at desc").limit(6)
  end
end