require 'rails_helper'

feature 'User edits post' do
  background do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:post, user: @user1)
    @post2 = create(:post, user: @user2)
    log_in_as(@user1)
  end

  scenario 'can edit owned post' do
    visit root_path
    find(:xpath, "//a[contains(@href, 'posts/1')]", match: :first).click
    click_link 'Edit'
    fill_in 'post_caption', with: "This is the new caption"
    click_button 'Update Post'
    expect(page).to have_content('Post has been updated.')
    expect(page).to have_content('This is the new caption')
  end

  scenario 'cannot edit post with blank caption' do
    visit root_path
    find(:xpath, "//a[contains(@href, 'posts/1')]", match: :first).click
    click_link 'Edit'
    fill_in 'post_caption', with: ""
    click_button 'Update Post'
    expect(page).to have_content("Post can't be updated.")
  end

  scenario "cannot edit other's post" do
    visit post_path(@post2)
    expect(page).to_not have_link("Edit")

    visit edit_post_path(@post2)
    expect(page).to have_content("That post doesn't belong to you")
  end

end
