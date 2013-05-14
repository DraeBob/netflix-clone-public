class Video < ActiveRecord::Base
  has_many :reviews
  has_many :video_categories
  has_many :categories, through: :video_categories

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    if search_term
      find(:all, conditions: ['title LIKE ?', "%#{search_term}%"])
    else
      find(:all)
    end
  end

  def recent_reviews
    reviews.order("created_at desc")
  end  

  def average_ratings
    if reviews.size > 0
      (reviews.collect(&:rate).inject{ |sum, el| sum + el }.to_f / reviews.size).round(1) 
    else
      0
    end
  end
end