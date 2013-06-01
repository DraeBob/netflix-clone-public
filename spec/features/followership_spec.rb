require 'spec_helper'

feature 'Followership' do
  background do 
    @user1 = Fabricate(:user, fullname: "John Smith", email: "johnsmith@example.com", password: "password") 
    @user2 = Fabricate(:user, fullname: "Bob Smith", email: "bobsmith@example.com", password: "password")
    @cat = Fabricate(:category, name: "Comedy")
    @video1 = Fabricate(:video, title: "Family Guy", description: "description", categories: [@cat])
    @video2 = Fabricate(:video, title: "Futurama", description: "description", categories: [@cat])
    @review1 = Fabricate(:review, rate: 3, body: "Damn", video: @video1, user: @user2)
  end

  scenario "@user1 folllow and unfollow @user2" do
    sign_in(@user1)
    visit video_path(@video1)
    page.should have_content @user2.fullname
    click_on @user2.fullname
    click_link "Follow"
    page.should have_content "Followership created"
    page.should have_content @user2.fullname
    within(:xpath, "//tr[contains(.,'#{@user2.fullname}')]") do
      find("a[data-method='delete']").click
    end
    page.should_not have_content @user2.fullname
  end
end