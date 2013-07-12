class Video < ActiveRecord::Base
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  has_many :reviews, order: "created_at desc"
  has_many :video_categories
  has_many :categories, through: :video_categories
  has_many :queue_videos

  validates :title, presence: true
  validates :description, presence: true

  def decorator
    VideoDecorator.new(self)
  end

  def self.search_by_title(search_term)
    if search_term.blank?
      find(:all)
    else
      find(:all, conditions: ['title LIKE ?', "%#{search_term}%"])
    end
  end 
end