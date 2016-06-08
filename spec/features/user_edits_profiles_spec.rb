require 'rails_helper'

feature 'User edits user profiles' do
  background do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:post, user: @user1, caption: 'hello')
    @post2 = create(:post, user: @user2, caption: 'world')
    log_in_as @user1
    visit browse_posts_path
  end

  scenario 'a user can change their own profile details' do
    first(:link, @user1.user_name).click
    click_link 'Edit Profile'
    attach_file('user_avatar', 'spec/files/images/avatar.jpeg')
    fill_in "user_bio", with: 'New bio here'
    click_button "Update Profile"
    expect(page.current_path).to eq profile_path(@user1.user_name)
    expect(page).to have_css("img[src*='avatar']")
    expect(page).to have_content('New bio here')
  end

  scenario "a user cannot change other's profile" do
    first(:link, @user2.user_name).click
    expect(page).to_not have_link('Edit Profile')
  end

  scenario "a user cannot change other's profile via url" do
    visit edit_profile_path(@user2.user_name)
    expect(page).to have_content("That profile doesn't belong to you!")
    expect(page.current_path).to eq root_path
  end
end
