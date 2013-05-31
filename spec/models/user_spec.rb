require 'spec_helper'

describe User do 
  it { should have_many(:reviews) }
  it { should validate_presence_of(:fullname) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should have_many(:queue_videos).order(:position) }
  it { should have_many(:followerships) }
  it { should have_many(:followers).through(:followerships) }
end

describe "#queued_already?" do
  let!(:user){ Fabricate(:user)}
  let!(:video){ Fabricate(:video)}
  it "returns true if user already queued the video" do
    Fabricate(:queue_video, user: user, video: video)
    user.queued_already?(video).should be_true
  end

  it "return false if user has not yet queued the video" do
    user.queued_already?(video).should be_false
  end
end
