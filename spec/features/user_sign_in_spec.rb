require 'spec_helper'

feature 'User signs in' do
  background { Fabricate(:user, fullname: "John Smith", email: "johnsmith@example.com", password: "password") }
  scenario "with registered user" do
    visit login_path
    fill_in "Email", with: "johnsmith@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
    page.should have_content("Welcome, you are logged in")
  end

  scenario "with incorrect input" do
    visit login_path
    fill_in "Email", with: "johnsmith@example.com"
    fill_in "Password", with: "xxxxxxxx"
    click_button "Sign in"
    page.should have_content("Email or password is incorrect")
  end
end