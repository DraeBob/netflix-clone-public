require 'spec_helper'

feature 'Invite friend' do
  scenario 'User successfully invites a friend, and accepts the invitation' do
    eminem = Fabricate(:user)
    sign_in(eminem)

    # 1. Invite friend
    visit invite_path
    fill_in "Friend's Name", with: 'Snoop Dogg'
    fill_in "Friend's Email Address", with: 'snoop@example.com'
    fill_in "Invitation Message", with: 'What up'
    click_button 'Send Invitation'
    click_link 'Sign Out'

    # 2. Open email & click link
    open_email 'snoop@example.com'
    current_email.click_link 'Register at myflix from here'

    # 3. Register information except email (prefilled)
    expect(page).to have_content 'Register'
    fill_in 'Password', with: 'password'
    fill_in 'Fullname', with: 'Snoop Dogg'
    click_button 'Register'

    # 4. Signed in automatically and go to people page to check followership
    expect(page).to have_content("Successfully registered")
    click_link 'People'
    expect(page).to have_content(eminem.fullname)
    click_link 'Sign Out'

    # 5. Eminem checks the followership
    sign_in(eminem)
    click_link 'People'
    expect(page).to have_content('Snoop Dogg')

    clear_email
  end
end