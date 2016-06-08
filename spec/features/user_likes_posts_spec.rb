require 'rails_helper'

feature 'User likes posts' do
  background do
    @user = create(:user)
    @post = create(:post, user: @user)
    log_in_as @user
    visit root_path
  end

  scenario 'can like a post' do
    click_link "like_#{@post.id}"
    expect(page).to have_css("a.glyphicon-heart")
    expect(page).to have_css("#likes_#{@post.id}>.user-name", text: @user.user_name)
  end

  scenario 'can unlike a post' do
    click_link "like_#{@post.id}"
    expect(page).to have_link("like_#{@post.id}", href: unlike_post_path(@post.id))
    click_link "like_#{@post.id}"
    expect(page).to have_link("like_#{@post.id}", href: like_post_path(@post.id))
    expect(page).to have_css("a.glyphicon-heart-empty")
    expect(page).to_not have_css("#likes_#{@post.id}>.user-name", text: @user.user_name)
  end
end
