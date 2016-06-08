require 'rails_helper'

feature 'Follow users' do
  background do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:post, user: @user1, caption: 'user 1 post')
    @post2 = create(:post, user: @user2, caption: 'user 2 post')
  end

  scenario 'can see posts of following users' do
    log_in_as @user1
    visit root_path
    expect(page).to_not have_content(@post2.caption)
    click_link 'All Posts'
    first(:link, @user2.user_name).click
    click_link 'Follow'
    visit root_path
    expect(page).to have_content(@post2.caption)
  end

end
