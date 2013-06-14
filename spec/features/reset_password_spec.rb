require 'spec_helper'

feature 'Reset password' do
  let(:anna){ Fabricate(:user)}
  
  scenario 'User reset the password' do
    clear_emails
    # 1. Signin page
    visit login_path
    
    # 2. Click "forgot password?"
    page.should have_content("forgot password?")
    click_link ("forgot password?")

    # 3. Forgot password page - Enter Email
    page.should have_content("We will send you an email with a link that you can use to reset your password.")
    fill_in("Email Address", with: anna.email)
    click_button("Send Email")

    # 4. Open Email, Click link
    open_email(anna.email)
    current_email.click_link 'Reset password'

    # 5. Rest password page - Enter new password, click "Reset password"
    page.should have_content 'Reset Your Password'
    fill_in("New Password", with: '123456')
    click_button('Reset Password')

    # 6. Signin oage redirected, sign in with new password
    page.should have_content 'Sign in'
    fill_in "Email", with: anna.email
    fill_in "Password", with: "123456"
    click_button "Sign in"
    page.should have_content("Welcome, you are logged in")
    page.should have_content(anna.fullname)

    clear_email
  end
end