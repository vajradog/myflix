require 'rails_helper'

feature "User resets password" do
  scenario "user successfully resets password" do
    john = Fabricate(:user, password: 'old_password')
    visit sign_in_path
    click_on "Forgot Password"
    fill_in "Email Address", with: john.email
    click_on "Send Email"

    open_email(john.email)
    current_email.click_link("Reset Password")

    fill_in "New Password", with: "new_password"
    click_on "Reset Password"

    fill_in "Email", with: john.email
    fill_in "Password", with: "new_password"
    click_on "Login"

    expect(page).to have_content(john.full_name)
  end
end

