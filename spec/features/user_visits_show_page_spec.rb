require 'rails_helper'

feature "user visits show page" do
  given(:alice) { Fabricate(:user) }
  given(:category) { Fabricate(:category) }
  given(:video) { Fabricate(:video, category_id: category.id) }

  background do
    sign_in(alice)
  end

  scenario "when unauthenticated, is redirected to sign in page" do
    sign_out 
    visit_show_page(alice)
    expect(current_path).to eq('/sign_in')
  end

  scenario "when authenticated, displays the users full name" do
    visit_show_page(alice)
    expect_page_to_have(alice.full_name)
  end

  scenario "when authenticated, displays the title of videos in users queue item" do
    Fabricate(:queue_item, user: alice, video_id: video.id)
    visit_show_page(alice)
    expect_page_to_have(video.title)
  end

  scenario "when authenticated, displays the video reviews of the user" do
    review = Fabricate(:review, video_id: video.id, user_id: alice.id)
    visit_show_page(alice)
    expect_page_to_have(review.content)
  end

  scenario "when authenticated, displays the video ratings of the user" do
    review = Fabricate(:review, video_id: video.id, user_id: alice.id, rating: 2)
    visit_show_page(alice)
    expect_page_to_have(review.rating) 
  end

  def expect_page_to_have(content)
    expect(page).to have_content(content) 
  end

  def visit_show_page(user)
    visit("/users/#{user.id}")
  end

  def sign_out
    visit('/sign_out')
  end
end
