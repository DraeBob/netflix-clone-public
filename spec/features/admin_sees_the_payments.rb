require 'spec_helper'

feature 'Admin ses payments' do
  background do
    alice = Fabricate(:user, fullname: "Alice Gomez", email:"alice@example.com")
    Fabricate(:payment, amount: 999, user: alice)
  end

  scenario 'Admin can see payments' do
    admin = Fabricate(:admin)
    sign_in(admin)

    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice Gomez")
    expect(page).to have_content("alice@example.com")
  end

  scenario 'General user cannot see payments' do
    bob = Fabricate(:user)
    sign_in(bob)

    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Alice Gomez")
    expect(page).not_to have_content("alice@example.com")   
  end
end