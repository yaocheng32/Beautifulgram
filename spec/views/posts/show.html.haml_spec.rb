require "rails_helper"

describe 'posts/show.html.haml' do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:post, user: @user1)
    assign(:post, @post1)
  end

  it 'shows edit link when owned post' do
    sign_in @user1
    render
    expect(rendered).to have_link('Edit Post', href: edit_post_path(@post1))
  end

  it "does not show edit link when other's post" do
    sign_in @user2
    render
    expect(rendered).to_not have_link('Edit Post', href: edit_post_path(@post1))
  end
end
