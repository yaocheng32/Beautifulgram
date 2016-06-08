require 'rails_helper'

feature 'User creates posts' do
  background do
    @user = create(:user)
    log_in_as(@user)
  end

  scenario 'can create a post' do
    visit root_path
    click_link 'New Post'
    attach_file 'post_image', 'spec/files/images/beach.jpg'
    fill_in 'post_caption', with: 'From the beach'
    click_button 'Create Post'
    expect(page).to have_content('From the beach')
    expect(page).to have_css("img[src*='beach.jpg']")
    expect(page).to have_content(@user.user_name)
  end

  scenario 'requires an image to create a post' do
    visit root_path
    click_link 'New Post'
    fill_in 'post_caption', with: 'From the beach'
    click_button 'Create Post'
    expect(page).to have_content('Post can\'t be created.')
  end

  scenario 'requires caption to create a post' do
    visit root_path
    click_link 'New Post'
    attach_file 'post_image', 'spec/files/images/beach.jpg'
    click_button 'Create Post'
    expect(page).to have_content('Post can\'t be created.')
  end
end
