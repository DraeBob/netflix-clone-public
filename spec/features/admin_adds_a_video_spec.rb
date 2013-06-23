require 'spec_helper'

feature 'Admin adds a new video' do
  scenario 'Admin can add a video' do
    admin = Fabricate(:admin)
    comedy = Fabricate(:category)
    sign_in(admin)

    visit new_admin_video_path
    fill_in "Title", with: "Iron Man 3"
    select comedy.name, from: "Category"
    fill_in "Description", with: "Awesome"
    attach_file "Large cover",'public/tmp/monk_large.jpg'
    attach_file "Small cover",'public/tmp/monk.jpg'
    fill_in "Video URL", with: 'http://youtube.com'
    click_button "Add Video"

    click_link 'Sign Out'
    sign_in

    visit video_path(Video.first)
    expect(page).to have_content("Iron Man 3")
    expect(page).to have_content("Awesome")
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://youtube.com']")
  end
end