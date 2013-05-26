require 'spec_helper'

feature 'Video show page' do
  background do 
    @user = Fabricate(:user, fullname: "John Smith", email: "johnsmith@example.com", password: "password") 
    @video1 = Fabricate(:video, title: "Family Guy", description: "description")
    @video2 = Fabricate(:video, title: "Futurama", description: "description")
  end

  scenario "Add a video to my queue if video is not added to my queue yet" do
    visit login_path
    fill_in "Email", with: "johnsmith@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
    page.should have_content("Welcome, you are logged in")

    visit video_path(@video1)
    page.should have_content("+ My Queue")

    click_on("+ My Queue") 
    # Automatically redirect to my_queue_path
    queue_video = Fabricate(:queue_video, user: @user, video: @video1)
    page.should have_content("Family Guy")
    page.should_not have_content("Futurama")
  end

  scenario "Update queued video order" do
    visit login_path
    fill_in "Email", with: "johnsmith@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
    page.should have_content("Welcome, you are logged in")

    visit video_path(@video1)
    page.should have_content("+ My Queue")

    click_on("+ My Queue") 
    # Automatically redirect to my_queue_path
    queue_video1 = Fabricate(:queue_video, user: @user, video: @video1)
    page.should have_content("Family Guy")

    visit video_path(@video2)
    click_on("+ My Queue")
    queue_video2 = Fabricate(:queue_video, user: @user, video: @video2)
    page.should have_content("Futurama")

    fill_in 'queue_videos__id', with: 2
    fill_in 'queue_videos[@video2.id][@video2.position]', with: 1
    click_on("Update Instant Queue")

    page.should have_selector('queue_videos2.position', 1)
    page.should have_selector('queue_videos1.position', 2)
  end

  # scenario "Update queued video rating" do
  # end
  # scenario "Cannot update queued video order if invalid input" do
  # end

end