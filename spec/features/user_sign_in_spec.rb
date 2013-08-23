require 'spec_helper'

feature 'User signs in' do
  scenario "with registered user" do
    alice = Fabricate(:user)
    visit login_path
    sign_in(alice)
    page.should have_content("Welcome, you are logged in")
    page.should have_content alice.fullname
  end

  scenario "with incorrect input" do
    john = Fabricate(:user, fullname: "John Smith", email: "johnsmith@example.com", password: "password")

    visit login_path
    fill_in "Email", with: "johnsmith@example.com"
    fill_in "Password", with: "xxxxxxxx"
    click_button "Sign in"
    page.should have_content("Email or password is incorrect")
  end

  scenario "with deactivated user" do
    alice = Fabricate(:user, active: false)
    sign_in(alice)
    expect(page).not_to have_content(alice.fullname)
    expect(page).to have_content("Your account has been suspended, please contact customer service.")
  end
end