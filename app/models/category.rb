class Category < ActiveRecord::Base

  has_many :video_categories
  has_many :videos, through: :video_categories

  validates :name, presence: true

  def recent_videos
    find(:all, limit: 6, order: "created_at desc")
  end
end