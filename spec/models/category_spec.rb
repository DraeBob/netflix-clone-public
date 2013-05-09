require 'spec_helper'

describe Category do
  it "save itself" do
    category = Category.new(name: 'Test category')
    category.save
    expect(Category.first).to eq(category)
  end

  it { should have_many(:videos).through(:video_categories) }
end