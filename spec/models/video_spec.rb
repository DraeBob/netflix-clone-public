require 'spec_helper'

describe Video do
  before :each do
    @video1 = Video.create(title: 'Family Guy', description: 'Some random description', small_cover_url: '/tmp/family_guy.jpg' , large_cover_url:'/tmp/monk_large.jpg')
    @video2 = Video.create(title: 'Futurama', description: 'Some random description', small_cover_url: '/tmp/family_guy.jpg' , large_cover_url:'/tmp/monk_large.jpg')
  end

  it "save itself" do
    @video1.save
    Video.first.should == @video1
  end

  it { should have_many(:categories).through(:video_categories) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  context "Using search_by_title" do
    it "should return all the videos if the keyword is found in video titles" do
      expect(Video.search_by_title("Guy")).to include @video1
    end

    it "should return empty array when nothing is found" do
      expect(Video.search_by_title("Test Title")).to eq []
    end
  end
end