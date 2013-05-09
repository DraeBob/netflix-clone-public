class Video < ActiveRecord::Base
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
end