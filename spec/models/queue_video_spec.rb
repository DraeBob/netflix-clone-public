require 'spec_helper'

describe QueueVideo do 
  it { should belong_to(:user)}
  it { should belong_to(:video)}

  describe "#video_title" do
    it "return the video title" do
      video = Fabricate(:video)
      queue_video = Fabricate(:queue_video, video: video)
      expect(queue_video.video_title).to eq("Family Guy")
    end
  end

  describe "#rate" do
    let!(:user){ Fabricate(:user)}
    let!(:video){ Fabricate(:video)}
    let!(:queue_video){ Fabricate(:queue_video, user: user, video: video) }
    it "return the rate of the review if user has review on the video" do
      review = Fabricate(:review, user: user, video: video, rate: 4)
      expect(queue_video.rate).to eq(4)
    end

    it "returns nil if the user does not have review on the video" do
      expect(queue_video.rate).to be_nil
    end
  end

  describe "#rate=" do
    let!(:user){ Fabricate(:user)}
    let!(:video){ Fabricate(:video)}
    let!(:queue_video){ Fabricate(:queue_video, user: user, video: video) }

    it "change the rate of the review if the review is present" do
      review = Fabricate(:review, user:user, video: video, rate: 2)
      queue_video.rate = 4
      expect(Review.first.rate).to eq(4)
    end

    it "clears the rate of the review if the review is present" do
      review = Fabricate(:review, user:user, video: video, rate: 2)
      queue_video.rate = nil
      expect(Review.first.rate).to be_nil
    end

    it "creates the review with rate if the review is not present" do
      queue_video.rate = 3
      expect(Review.first.rate).to eq(3)
    end
  end

  describe "#category_name" do
    it "return the first name of categories of the video" do
      com = Fabricate(:category, name: 'Comedy')
      cat = Fabricate(:category)
      vid = Fabricate(:video, categories: [com,cat])
      queue_video = Fabricate(:queue_video, video: vid)
      expect(queue_video.category_names).to eq("Comedy")
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      com = Fabricate(:category, name: 'Comedy')
      cat = Fabricate(:category)
      vid = Fabricate(:video, categories: [com,cat])
      queue_video = Fabricate(:queue_video, video: vid)
      expect(queue_video.categories).to eq([com, cat])
    end    
  end
end