require 'spec_helper'

describe Video do
  it "save itself" do
    video = Video.new(title: 'Test Title', description: 'Some random description', small_cover_url: '/tmp/family_guy.jpg' , large_cover_url:'/tmp/monk_large.jpg')
    video.save
    Video.first.title.should == 'Test Title'
  end

  it { should have_many(:categories).through(:video_categories) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end