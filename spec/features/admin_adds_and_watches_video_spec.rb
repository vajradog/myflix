require 'rails_helper'

feature "Admin adds and watches video" do
  scenario "admin successfully adds and watches a new video" do
    admin = Fabricate(:admin)
    Fabricate(:category, name: "Action")
    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Rambo"
    select 'Action', from: 'Category'
    fill_in "Description", with: "A very fast action movie"
    attach_file('video[large_cover]', File.join(Rails.root, '/spec/support/uploads/large_ponyo.jpg'))
    attach_file('video[small_cover]', File.join(Rails.root, '/spec/support/uploads/ponyo.jpg'))
    fill_in "Video Url", with: "http://example.com/some_video.mp4"
    click_button "Add Video"

    sign_out
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/large_ponyo.jpg']")
    expect(page).to have_selector("a[href='http://example.com/some_video.mp4']")
  end
end
