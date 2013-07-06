require 'spec_helper'

feature 'Registration' do
  scenario "successful registration", js: true do
    visit new_user_path

    fill_in 'Email', with: 'dyankee@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Fullname', with: 'Daddy Yankee'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '123'
    select '3 - March', from: 'date_month'
    select '2015', from: 'date_year'

    click_button 'Register'

    expect(page).to have_content("Successfully registered")

    clear_email
  end
end