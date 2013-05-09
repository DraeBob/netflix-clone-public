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
      @comedy = Category.create(name: 'Comdey')
      @cartoon = Category.create(name: 'Cartoon')
      @drama = Category.create(name: 'Drama')
      @family = Category.create(name: 'Family')
      @video1 = Video.create(title: 'Family Guy', description: 'Some random description', categories:[@comedy, @family])
      @video2 = Video.create(title: 'South Park', description: 'Some random description', categories:[@drama, @cartoon, @comedy])
      @video3 = Video.create(title: 'Futurama', description: 'Some random description', categories:[@comedy, @family])
      @video4 = Video.create(title: 'Family Guy 2', description: 'Some random description', categories:[@comedy, @family])
      @video5 = Video.create(title: 'South Park 2', description: 'Some random description', categories:[@comedy, @cartoon, @family, @drama])
      @video6 = Video.create(title: 'Futurama 2', description: 'Some random description', categories:[@comedy, @cartoon, @family, @drama])
      @video7 = Video.create(title: 'Family Guy 3', description: 'Some random description', categories:[@comedy, @cartoon, @drama])
      @video8 = Video.create(title: 'South Park 3', description: 'Some random description', categories:[@comedy, @family, @drama])
      @video9 = Video.create(title: 'Futurama 3', description: 'Some random description', categories:[@comedy, @cartoon])
    end

    it "should display recent video first" do
      expect(Video.order('created_at desc').first).to eq(@video9)
    end

    it "should display maximum 6 videos par category" do
      expect(Video.limit(6).last).to eq(@video6)
    end
  end
end