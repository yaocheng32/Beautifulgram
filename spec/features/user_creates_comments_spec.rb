require 'rails_helper'

feature 'User creates comments' do
  background do
    @user1 = create(:user)
    @post1 = create(:post, user: @user1)
    @user2 = create(:user)
    @post2 = create(:post, user: @user2)
    log_in_as(@user1)
  end

  scenario 'can create comment' do
    visit root_path
    click_link 'All Posts'
    fill_in 'comment_content_1', with: 'My comment'
    click_button 'submit_comment_1'
    expect(page).to have_content('My comment')

    click_link 'All Posts'
    fill_in 'comment_content_2', with: 'Another comment'
    click_button 'submit_comment_2'
    expect(page).to have_content('Another comment')
  end

end
