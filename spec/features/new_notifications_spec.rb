require 'rails_helper'

feature 'New notifications' do
  background do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:post, user: @user1)
    @post2 = create(:post, user: @user2)
  end

  scenario 'creates notification when commenting' do
    log_in_as @user1
    #visit root_path
    visit browse_posts_path
    fill_in 'comment_content_2', with: 'My comment'
    click_button 'submit_comment_2'
    click_link 'Logout'
    log_in_as @user2
    expect(page).to have_css("a[href='#{link_through_path(1)}']")
    find(:css, "a[href='#{link_through_path(1)}']").click
    expect(page.current_path).to eq post_path(2)
    visit root_path
    expect(page).to_not have_css("a[href='#{link_through_path(1)}']")
    visit notifications_path
    expect(page).to have_css("a[href='#{link_through_path(1)}']")
  end

  scenario 'creates notification when liking' do
    log_in_as @user1
    #visit root_path
    visit browse_posts_path
    click_link 'like_2'
    click_link 'Logout'
    log_in_as @user2
    expect(page).to have_css("a[href='#{link_through_path(1)}']")
    find(:css, "a[href='#{link_through_path(1)}']").click
    expect(page.current_path).to eq post_path(2)
    visit root_path
    expect(page).to_not have_css("a[href='#{link_through_path(1)}']")
    visit notifications_path
    expect(page).to have_css("a[href='#{link_through_path(1)}']")
  end
end
