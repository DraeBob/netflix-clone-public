class QueueVideo < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  delegate :categories, to: :video

  def video_title
    video.title
  end

  def rate
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rate if review
  end

  def category_names 
    video.categories.collect(&:name).first
  end
end