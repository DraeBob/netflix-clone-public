require 'spec_helper'

describe Category do
  it "save itself" do
    category = Category.new(name: 'Test category')
    category.save
    Category.first.name.should == 'Test category'
  end

  it { should have_many(:videos).through(:video_categories) }
end