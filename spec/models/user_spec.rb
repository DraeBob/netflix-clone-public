require 'spec_helper'

describe User do 
  it { should have_many(:reviews) }
  it { should validate_presence_of(:fullname) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should have_many(:my_queued_videos).through(:queue_videos) }

  describe "#push_my_queued_videos" do
    let!(:user) { Fabricate(:user) }
    let!(:video) { Fabricate(:video) }

    it "should queue the video the user chooses" do
      user.push_my_queued_videos(video)
      expect(user.my_queued_videos).to eq [video]
    end
  end

  describe "#delete_my_queued_videos" do
    let!(:user) { Fabricate(:user) }
    let!(:video) { Fabricate(:video) }

    it "should queue the video the user chooses" do
      user.push_my_queued_videos(video)
      user.delete_my_queued_videos(video)
      expect(user.my_queued_videos).to eq []
    end    
  end
end