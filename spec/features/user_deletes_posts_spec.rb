require 'rails_helper'

feature 'User deletes posts' do
  background do
    user = create(:user)
    post = create(:post, caption: 'To be deleted', user: user)
    log_in_as(user)
    visit root_path
    find(:xpath, "//a[contains(@href, 'posts/1')]", match: :first).click
    click_link 'Edit'
  end

  scenario 'can delete a post' do
    click_link 'Delete'
    expect(page).to have_content('Post has been deleted.')
    expect(page).to_not have_content('To be deleted')
  end
end
