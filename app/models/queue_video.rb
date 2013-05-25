class QueueVideo < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  delegate :categories, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :position, {only_integer: true}

  def rate
    review.rate if review
  end

  def rate=(new_rate)
    if review
      review.update_column(:rate, new_rate)
    else
      review = Review.new(user: user, video: video, rate: new_rate)
      review.save(validate: false)
    end
  end

  def category_names 
    video.categories.collect(&:name).first
  end

  private 

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end