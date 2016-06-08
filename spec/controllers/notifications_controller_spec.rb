require 'rails_helper'

describe NotificationsController do
  describe 'GET #index' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      (1..10).each do
        create(:notification, user: @user1)
        create(:notification, user: @user2)
      end
      sign_in @user1
    end

    it 'requires login' do
      sign_out @user1
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'assigns notifications' do
      get :index
      @user1.notifications.each do |n|
        expect(assigns(:notifications)).to include(n)
      end
      @user2.notifications.each do |n|
        expect(assigns(:notifications)).to_not include(n)
      end
    end
  end

  describe 'GET #link_through' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @notification1 = create(:notification, user: @user1)
      sign_in @user1
    end

    it 'requires login' do
      sign_out @user1
      get :link_through, id: 1
      expect(response).to redirect_to(new_user_session_path)
    end

    it "cannot access other's notifications" do
      sign_out @user1
      sign_in @user2
      get :link_through, id: @notification1
      expect(response).to redirect_to(root_path)
    end

    it 'makes the notification read' do
      expect(@notification1.read).to eq false
      get :link_through, id: @notification1
      @notification1.reload
      expect(@notification1.read).to eq true
    end

    it 'redirects to the post' do
      get :link_through, id: @notification1
      expect(response).to redirect_to(post_path(@notification1.post))
    end
  end
end
