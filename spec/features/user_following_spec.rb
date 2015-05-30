require 'rails_helper'

feature "User following" do
  scenario "user follows and unfollows someone" do
    alice = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, video_id: video.id, user_id: alice.id)

    sign_in
    click_on_the_video(video)
    click_link alice.full_name
    click_link 'Follow'
    leaders_name_should_be_present_on_people_page(alice)

    unfollow(alice)
    leaders_name_should_not_be_present_on_people_page(alice)
  end

  def click_on_the_video(video)
    find("a[href='/videos/#{video.id}']").click
  end

  def leaders_name_should_be_present_on_people_page(leader)
    expect(page).to have_content(leader.full_name)
  end

  def unfollow(leader)
    find("a[data-method='delete']").click
  end

  def leaders_name_should_not_be_present_on_people_page(leader)
    expect(page).to_not have_content(leader.full_name)
  end
end
