class VideoDecorator < Draper::Decorator
  delegate_all

  def average_ratings
    if reviews.size > 0
      (reviews.collect(&:rate).sum.to_f / reviews.size).round(1) 
    else
      0
    end
  end

end