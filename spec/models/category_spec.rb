require 'spec_helper'

describe Category do
  it "save itself" do
    category = Category.new(name: 'Comdey')
    category.save
    expect(Category.first).to eq(category)
  end

  it { should have_many(:videos).through(:video_categories) }

  context "recent video" do
    before :each do
      @family = Category.create!(name: 'Family')
      @comedy = Category.create!(name: 'Comedy')
      7.times {Video.create!(title: 'Family Guy', description: 'Some random description', categories:[@comedy])}
    end

    it "should display none if there is no video in the category" do
      expect(@family.recent_videos.count).to eq(0)
    end

    it "should display maximum 6 videos par category" do
      expect(@comedy.recent_videos.count).to eq(6)
    end

    it "should return reverse chronologial order" do
      expect(@comedy.recent_videos.first).to eq(Video.order('created_at desc').first)
      expect(@comedy.recent_videos.last).to eq(Video.order('created_at desc').limit(6).last)
    end
  end
end