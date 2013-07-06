require 'spec_helper'

describe Video do

  it "save itself" do
    video = Video.new(title: 'Family Guy', description: 'Some random description')
    video.save
    Video.first.should == video
  end

  it { should have_many(:reviews).order("created_at desc") }
  it { should have_many(:categories).through(:video_categories) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#search_by_title" do
    let!(:video) { Fabricate(:video, title: 'Family Guy', description: 'description1')}
    let!(:video2) { Fabricate(:video, title: 'Futurama', description: 'description2')}

    it "should return all the videos if the keyword is found in video titles" do
      expect(Video.search_by_title("F")).to include(video2, video)
    end

    it "should return empty array when nothing is found" do
      expect(Video.search_by_title("Test Title")).to eq []
    end

    it "should return the video if the search keyword matches exactly" do
      expect(Video.search_by_title("Family Guy")).to include video
    end

    it "should return all the videos if the keyword is empty" do
      expect(Video.search_by_title("")).to include(video2, video)
    end  
  end

  describe "#average_ratings" do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}

    it "should return 0 if there is no review" do
      expect(video.decorator.average_ratings).to eq 0
    end
    it "should return the average review if there are any reviews" do
      video.reviews << Fabricate(:review, body: "aaa", rate: 2)
      video.reviews << Fabricate(:review, body: "aaa", rate: 5)
      expect(video.decorator.average_ratings).to eq(3.5)
    end
  end
end