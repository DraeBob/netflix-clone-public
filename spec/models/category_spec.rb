require 'spec_helper'

describe Category do
  it "save itself" do
    category = Category.new(name: 'Comdey')
    category.save
    expect(Category.first).to eq(category)
  end

  it { should have_many(:videos).through(:video_categories) }

  describe "#recent_videos" do

    let(:family) {Fabricate(:category, name: 'Family')}
    let(:comedy) {Fabricate(:category, name: 'Comedy')}
    before { 7.times {Fabricate(:video, title: 'Family Guy', description: 'Some random description', categories: [comedy])} }

    it "should display none if there is no video in the category" do
      expect(family.recent_videos.count).to eq(0)
    end

    it "should display maximum 6 videos par category" do
      expect(comedy.recent_videos.count).to eq(6)
    end

    it "should return reverse chronologial order" do
      expect(comedy.recent_videos.first).to eq(Video.order('created_at desc').first)
      expect(comedy.recent_videos.last).to eq(Video.order('created_at desc').limit(6).last)
    end
  end
end