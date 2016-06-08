require 'rails_helper'

describe User do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:post, user: @user1)
    @post2 = create(:post, user: @user2)
  end

  it 'default factory is valid' do
    expect(@post1).to be_valid
  end

  it 'does not accept avatar which is not a image' do
    @user1.avatar = File.new("spec/files/others/test.txt")
    expect(@user1).to_not be_valid
  end

  it 'requires user_name' do
    @user1.user_name = ''
    expect(@user1).to_not be_valid
    @user1.user_name = '1'
    expect(@user1).to_not be_valid
    @user1.user_name = '1'*200
    expect(@user1).to_not be_valid
  end

  it '.follow' do
    @user1.follow(@user2.id)
    expect(@user1.followings).to include(@user2)
    expect(@user2.followers).to include(@user1)
  end

  it '.unfollow' do
    @user1.follow(@user2.id)
    @user1.unfollow(@user2.id)
    expect(@user1.followings).to_not include(@user2)
    expect(@user2.followers).to_not include(@user1)
  end

  it '.feed' do
    expect(@user1.feed).to include(@post1)
    expect(@user1.feed).to_not include(@post2)
    @user1.follow(@user2.id)
    expect(@user1.feed).to include(@post1)
    expect(@user1.feed).to include(@post2)
  end
end
