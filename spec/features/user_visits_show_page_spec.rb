require 'rails_helper'

feature "user visits show page" do
  scenario "when unauthenticated, is redirected to sign in page" do
    visit('/users/1')
    expect(current_path).to eq('/sign_in')
  end

  scenario "when authenticated, displays the users full name" do
    user = Fabricate(:user)
    sign_in
    visit_show_page(user)
    expect_page_to_have(user.full_name)
  end

  scenario "when authenticated, displays the title of videos in users queue item" do
    user = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category_id: category.id)
    queue_item1 = Fabricate(:queue_item, user: user, video_id: video.id)
    sign_in
    visit_show_page(user)
    expect_page_to_have(video.title)
  end

  scenario "when authenticated, displays the video reviews of the user" do
    user = Fabricate(:user)
    sign_in
    category = Fabricate(:category)
    video = Fabricate(:video, category_id: category.id)
    review = Fabricate(:review, video_id: video.id, user_id: user.id)
    visit_show_page(user)
    expect_page_to_have(review.content)
  end

  scenario "when authenticated, displays the video ratings of the user" do
    user = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category_id: category.id)
    review = Fabricate(:review, video_id: video.id, user_id: user.id, rating: 2)
    sign_in
    visit_show_page(user)
    expect_page_to_have(review.rating) 
  end

  def expect_page_to_have(content)
    expect(page).to have_content(content) 
  end

  def visit_show_page(user)
    visit("/users/#{user.id}")
  end

end