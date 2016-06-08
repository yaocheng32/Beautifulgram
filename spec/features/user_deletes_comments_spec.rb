require 'rails_helper'

feature 'User deletes comments' do
  background do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:post, user: @user1)
    @comment = create(:comment, user: @user2, post: @post1, content: "Good comment")
  end

  scenario 'can delete own comment' do
    log_in_as(@user2)
    visit post_path(@post1)
    expect(page).to have_content(@comment.content)
    click_link 'delete-comment-1'
    expect(page).to_not have_content(@comment.content)
  end

  scenario "cannot delete other's comment" do
    log_in_as(@user1)
    visit post_path(@post1)
    expect(page).to have_content(@comment.content)
    expect(page).to_not have_link 'delete-comment-1'
  end

  scenario "delete a comment not belonging to them via url" do
    log_in_as(@user1)
    visit post_path(@post1)
    page.driver.submit :delete, post_comment_path(@post1, @comment), {}
    expect(page).to have_content("That doesn't belong to you!")
    expect(page).to have_content(@comment.content)
  end
end
