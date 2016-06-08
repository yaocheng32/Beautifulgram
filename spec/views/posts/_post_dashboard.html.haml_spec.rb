require "rails_helper"

describe "posts/_post_dashboard.html.haml" do
  before (:each) do
    @user = create(:user)
    (1..10).each { create(:post, user: @user) }
    sign_in @user
    @posts = Post.all.page(1).per(8)
    assign(:posts, @posts)
  end

  it 'display posts with specified page' do
    render
    @posts.each do |post|
      expect(rendered).to have_content(post.caption)
    end
    Post.all.page(2).per(8).each do |post|
      expect(rendered).to_not have_content(post.caption)
    end
    expect(rendered).to have_css("#load_more")
  end

  it 'does not show load more when at the end of posts' do
    assign(:posts, Post.all.page(2).per(8))
    expect(rendered).to_not have_css("#load_more")
  end
end
