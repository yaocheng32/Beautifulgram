require 'rails_helper'

describe RelationshipsController do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    request.env['HTTP_REFERER'] = root_path
    sign_in @user1
  end

  describe 'POST #follower_user' do
    it 'requires login' do
      sign_out @user1
      post :follow_user, user_name: @user2.user_name
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'follows user' do
      post :follow_user, user_name: @user2.user_name
      expect(@user1.followings).to include(@user2)
      expect(@user2.followers).to include(@user1)
    end

    it 'cannot follow self' do
      post :follow_user, user_name: @user1.user_name
      expect(response).to redirect_to(root_path)
      expect(@user1.followings).to_not include(@user1)
      expect(@user1.followers).to_not include(@user1)
    end
  end

  describe 'POST #unfollower_user' do
    it 'requires login' do
      sign_out @user1
      post :unfollow_user, user_name: @user2.user_name
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'unfollows user' do
      post :follow_user, user_name: @user2.user_name
      expect(@user1.followings).to include(@user2)
      expect(@user2.followers).to include(@user1)
      post :unfollow_user, user_name: @user2.user_name
      expect(@user1.followings).to_not include(@user2)
      expect(@user2.followers).to_not include(@user1)
    end

    it 'cannot unfollow self' do
      post :unfollow_user, user_name: @user1.user_name
      expect(response).to redirect_to(root_path)
      expect(@user1.followings).to_not include(@user1)
      expect(@user1.followers).to_not include(@user1)
    end
  end
end
