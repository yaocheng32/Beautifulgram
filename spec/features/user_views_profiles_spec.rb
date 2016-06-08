require 'rails_helper'

feature 'User views profiles' do
  background do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:post, user: @user1, caption: 'hello')
    @post2 = create(:post, user: @user2, caption: 'world')
    log_in_as @user1
    visit root_path
    first(:link, @user1.user_name).click
  end

  scenario 'visiting a profile page shows the user name in the url' do
    expect(page).to have_content(@user1.user_name)
  end

  scenario "a profile page only shows the specified user's posts" do
    expect(page).to have_content(@post1.caption)
    expect(page).to_not have_content(@post2.caption)
  end
end
