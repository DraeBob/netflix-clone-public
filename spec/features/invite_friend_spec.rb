require 'spec_helper'

feature 'Invite friend' do
  scenario 'User successfully invites a friend, and accepts the invitation', js: true do
    eminem = Fabricate(:user)
    sign_in(eminem)

    invite_a_friend(eminem)
    friend_accepts_the_invitation

    friend_follows_inviter(eminem)
    inviter_follows_friend(eminem)

    clear_email
  end

  def invite_a_friend(inviter)
    visit invite_path
    fill_in "Friend's Name", with: 'Snoop Dogg'
    fill_in "Friend's Email Address", with: 'snoop@example.com'
    fill_in "Invitation Message", with: 'What up'
    click_button 'Send Invitation'
    click_link "Welcome, #{inviter.fullname}"
    click_link 'Sign Out'
  end

  def friend_accepts_the_invitation
    open_email 'snoop@example.com'
    current_email.click_link 'Register at myflix from here'

    expect(page).to have_content 'Register'
    fill_in 'Password', with: 'password'
    fill_in 'Fullname', with: 'Snoop Dogg'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '123'
    select '3 - March', from: 'date_month'
    select '2015', from: 'date_year'

    click_button 'Register'

    expect(page).to have_content("Successfully registered")
  end

  def friend_follows_inviter(inviter)
    click_link 'People'
    expect(page).to have_content(inviter.fullname)
    click_link "Welcome, Snoop Dogg"
    click_link 'Sign Out'
  end

  def inviter_follows_friend(inviter)
    sign_in(inviter)
    click_link 'People'
    expect(page).to have_content('Snoop Dogg')
  end
end