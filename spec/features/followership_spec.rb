require 'spec_helper'

feature 'Followership' do
  scenario "ann folllow and unfollow bob" do
    ann = Fabricate(:user) 
    bob = Fabricate(:user) 
    cat = Fabricate(:category, name: "Comedy")
    video = Fabricate(:video, categories: [cat]) 
    review = Fabricate(:review, video: video, user: bob)   

    sign_in(ann)
    visit video_path(video)
    page.should have_content bob.fullname
    click_on bob.fullname

    click_link "Follow"
    page.should have_content "following relationships created"
    page.should have_content bob.fullname
    unfollow(bob)
  end

  def unfollow(user)
    within(:xpath, "//tr[contains(.,'#{user.fullname}')]") do
      find("a[data-method='delete']").click
    end
    page.should_not have_content user.fullname
  end
end