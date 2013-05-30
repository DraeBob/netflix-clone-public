require 'spec_helper'

feature 'Video show page' do
  background do 
    @user = Fabricate(:user, fullname: "John Smith", email: "johnsmith@example.com", password: "password") 
    @video = Fabricate(:video, title: "Family Guy", description: "description")
  end

  scenario "Show my queue button if video is not added to my queue yet" do
    visit login_path
    fill_in "Email", with: "johnsmith@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
    page.should have_content("Welcome, you are logged in")

    visit video_path(@video)
    page.should have_content("+ My Queue")
  end

  scenario "Hide my queue button if already added to my queue" do
    visit login_path
    fill_in "Email", with: "johnsmith@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
    page.should have_content("Welcome, you are logged in")

    visit video_path(@video)
    page.should have_content("+ My Queue")

    click_on("+ My Queue") 
    # Automatically redirect to my_queue_path
    queue_video = Fabricate(:queue_video, user: @user, video: @video)
    page.should have_content("Family Guy")
    page.should_not have_content("Futurama")

    click_link("Family Guy")
    # Automatically redirect to video_path(@video)
    page.should_not have_content("+ My Queue")
  end
end