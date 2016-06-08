require 'rails_helper'

feature 'Show individual posts' do
  scenario 'can click and view a single post' do
    post = create(:post)
    log_in_as(post.user)
    visit root_path
    find(:xpath, "//a[contains(@href, 'posts/1')]", match: :first).click
    expect(current_path).to eq post_path(post)
  end
end
