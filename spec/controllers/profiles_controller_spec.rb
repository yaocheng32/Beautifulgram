require 'rails_helper'

describe ProfilesController do
  before(:each) do
    @user = create(:user)
    (1..10).each { create(:post, user: @user) }
    sign_in @user
  end

  describe 'GET #show' do
    it 'requires login' do
      sign_out @user
      get :show, user_name: @user.user_name
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'assigns user' do
      get :show, user_name: @user.user_name
      expect(assigns(:user)).to eq @user
    end

    it 'assigns posts' do
      get :show, user_name: @user.user_name
      expect(assigns(:posts)).to eq @user.posts.order("created_at DESC")
    end

    it 'renders :show' do
      get :show, user_name: @user.user_name
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    it 'requires login' do
      sign_out @user
      get :edit, user_name: @user.user_name
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'assigns user' do
      get :edit, user_name: @user.user_name
      expect(assigns(:user)).to eq @user
    end

    it 'renders :edit' do
      get :edit, user_name: @user.user_name
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    it 'requires login' do
      sign_out @user
      patch :update, user_name: @user.user_name
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'updates user' do
      name = @user.user_name + "1"
      email = @user.email + "2"
      bio = "new bio!"
      patch :update, user_name: @user.user_name, user: attributes_for(:user, user_name: name, email: email, bio: bio)
      @user.reload
      expect(@user.bio).to eq bio
      # does not change user_name & email
      expect(@user.user_name).to_not eq name
      expect(@user.email).to_not eq email
    end

    it "cannot update other's profile" do
      patch :update, user_name: create(:user).user_name
      expect(response).to redirect_to(root_path)
    end
  end
end
