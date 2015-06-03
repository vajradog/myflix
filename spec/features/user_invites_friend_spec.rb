require 'rails_helper'

feature "User invites friend" do
  scenario "user successfully invites friend and invitation is accepted" do
    alice = Fabricate(:user)
    sign_in(alice)

    invite_a_friend
    friend_accepts_invitation
    friend_should_follow(alice)
    inviter_should_follow_friend(alice)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friends Name", with: "John Doe"
    fill_in "Friends email", with: "john@example.com"
    fill_in "Message", with: "Hey John this is a cool website"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email "john@example.com"
    current_email.click_link "Accept this invitation"

    fill_in "Password", with: "password"
    fill_in "Full Name", with: "John Doe"
    click_on "Sign Up"
  end

  def friend_should_follow(alice)
    click_link "People"
    expect(page).to have_content alice.full_name
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "John Doe"
  end


end
