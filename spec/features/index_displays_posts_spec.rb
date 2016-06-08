require 'rails_helper'

feature 'Index displays a list of posts' do
  scenario 'the index displays correct created post information' do
    user = create(:user)
    p1 = create(:post, caption: 'Post 1', user: user)
    p2 = create(:post, caption: 'Post 2', user: user)
    log_in_as(user)

    visit root_path
    expect(page).to have_content('Post 1')
    expect(page).to have_content('Post 2')
    expect(page).to have_css("img[src*='beach']")
  end
end
