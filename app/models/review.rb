class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :body, presence: true
  validates :rate, presence: true
end