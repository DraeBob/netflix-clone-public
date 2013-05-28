require 'spec_helper'

feature 'Video show page' do
  background do 
    @user = Fabricate(:user, fullname: "John Smith", email: "johnsmith@example.com", password: "password") 
    @cat = Fabricate(:category, name: "Comedy")
    @video1 = Fabricate(:video, title: "Family Guy", description: "description", categories: [@cat])
    @video2 = Fabricate(:video, title: "Futurama", description: "description", categories: [@cat])
  end

  scenario "Add a video to my queue if video is not added to my queue yet" do
    sign_in(@user)

    visit video_path(@video1)
    page.should have_content("+ My Queue")

    click_on("+ My Queue") 
    queue_video = Fabricate(:queue_video, user: @user, video: @video1)
    page.should have_content("Family Guy")
    page.should_not have_content("Futurama")
  end

  scenario "Update queued video order" do
    sign_in(@user)

    visit video_path(@video1)
    page.should have_content("+ My Queue")

    click_on("+ My Queue") 
    expect_to_have_video_in_queue(@video1)

    visit video_path(@video2)
    click_on("+ My Queue")
    page.should have_content("Futurama")

    set_video_position(@video1, 2)
    set_video_position(@video2, 1)
    click_button "Update Instant Queue"
    expect_video_position(@video1, 2)
    expect_video_position(@video2, 1)
  end

  def expect_to_have_video_in_queue(video)
    page.should have_content(video.title)
  end

  def add_video_to_queue(video)
    visit videos_path
    find("a[href='/videos/#{video.id}']").click
    click_on("+ My Queue")
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_videos[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end