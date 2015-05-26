require 'rails_helper'

feature "User interacts with social networking" do
  given(:alice) { Fabricate(:user) }
  given(:bob) { Fabricate(:user) }

  scenario "when logged in can follow a user" do
    monk   = Fabricate(:video, category: Fabricate(:category))
    review = Fabricate(:review, video_id: monk.id, user_id: bob.id)
    sign_in(alice)

    click_on_the_video(monk)
    click_on_name_of_the_reviewer(bob)
    click_on_the_follow_button(bob)

    leaders_name_should_be_present_on_people_page(bob)
  end

  scenario "when logged in a follower can unfollow a leader" do
    relationship = Fabricate(:relationship, follower: alice, leader: bob)
    sign_in(alice)
    visit people_path

    click_on_the_unfollow_link(relationship)

    leaders_name_should_not_be_present_on_people_page(bob)
  end

  def click_on_the_video(video)
    find("a[href='/videos/#{video.id}']").click
  end

  def click_on_name_of_the_reviewer(reviewer)
    find("a[href='/users/#{reviewer.id}']").click
  end

  def click_on_the_follow_button(leader)
    find("a[href='/relationships?leader_id=#{leader.id}']").click
  end

  def leaders_name_should_be_present_on_people_page(leader)
    expect(page).to have_content(leader.full_name)
  end

  def click_on_the_unfollow_link(relationship)
    find("a[href='/relationships/#{relationship.id}']").click
  end

  def leaders_name_should_not_be_present_on_people_page(leader)
    expect(page).to_not have_content(leader.full_name)
  end
end
