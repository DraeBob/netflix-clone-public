require 'spec_helper'

feature 'Video show page' do
  background do
   Fabricate(:user)
   #session[:user_id] = user.id
   #set_current_user
   Fabricate(:video)
 end
  scenario "Show my queue button if not added to my queue yet" do
    visit video_path(video)
    page.should have_content("+ My Queue")
  end

  scenario "Hide my queue button if already added to my queue" do
    Fabricate(:queue_video, user: user, video: video)
    visit video_path(video)
    page.should_not have_content("+ My Queue")
  end
end