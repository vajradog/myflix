require 'rails_helper'

feature "user signs in" do
  scenario "with valid credentials, users can sign in" do
    bob = Fabricate(:user)
    sign_in(bob)
    expect_page_to_have_content(bob.full_name)
  end

  scenario "with valid credentials and see success notice" do
    sign_in
    expect_page_to_have_content("Signed in")
  end

  scenario "with invalid credentials and gets redirected to sign in page" do
    sign_in_with_invalid_credentials
    expect_page_to_have_content("Email")
  end

  scenario "with invalid credentials and see error notice" do
    sign_in_with_invalid_credentials
    expect_page_to_have_content("Either your password or email is incorrect")
  end

  def sign_in_with_invalid_credentials
    tom = Fabricate(:user)
    visit('/sign_in')
    fill_in('email', with: tom.email)
    fill_in('password', with: "wrong_password")
    click_button('Login')
  end

  def expect_page_to_have_content(text)
    expect(page).to have_content(text)
  end
end
