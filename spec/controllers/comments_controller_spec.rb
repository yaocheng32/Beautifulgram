require 'rails_helper'

describe CommentsController do
  before(:each) do
    @user1 = create(:user)
    @post1 = create(:post, user: @user1)
    @user2 = create(:user)
    @post2 = create(:post, user: @user2)
  end

  describe 'GET #index' do
    before(:each) do
      (1..10).each do
        create(:comment, user: @user1, post: @post1)
        create(:comment, user: @user1, post: @post2)
      end
      sign_in @user1
      get :index, post_id: @post1
    end

    it 'requires login' do
      sign_out @user1
      get :index, post_id: @post1
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'assigns all comments of a post' do
      @post1.comments.each do |c|
        expect(assigns(:comments)).to include(c)
      end
      @post2.comments.each do |c|
        expect(assigns(:comments)).to_not include(c)
      end
    end

    it 'renders :index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    before(:each) do
      sign_in @user1
      request.env['HTTP_REFERER'] = posts_path
    end

    it 'requires login' do
      sign_out @user1
      post :create, post_id: @post1, id: 1
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with valid attributes' do
      it 'creates a new comment' do
        expect {
          post :create, post_id: @post1, comment: attributes_for(:comment)
        }.to change(Comment, :count).by(1)
      end

      it 'does not create a new notification when commenting on own post' do
        expect {
          post :create, post_id: @post1, comment: attributes_for(:comment)
        }.to_not change(Notification, :count)
      end

      it "creates a new notification when commenting on other's post" do
        expect {
          post :create, post_id: @post2, comment: attributes_for(:comment)
        }.to change(Notification, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new comment' do
        expect {
          post :create, post_id: @post1, comment: attributes_for(:invalid_comment)
        }.to_not change(Comment, :count)
      end

      it 'does not create a new notification' do
        expect {
          post :create, post_id: @post2, comment: attributes_for(:invalid_comment)
        }.to_not change(Notification, :count)
      end

      it 'redirects to root' do
        post :create, post_id: @post1, comment: attributes_for(:invalid_comment)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @comment1 = create(:comment, post: @post1, user: @user1)
      @comment2 = create(:comment, post: @post1, user: @user2)
      sign_in @user1
      request.env['HTTP_REFERER'] = post_path(@post1)
    end

    it 'requires login' do
      sign_out @user1
      delete :destroy, post_id: @post1, id: 1
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'deletes the comment' do
      expect {
        delete :destroy, post_id: @post1, id: @comment1
      }.to change(Comment, :count).by(-1)
    end

    it "cannot delete other's comment" do
      expect {
        delete :destroy, post_id: @post1, id: @comment2
      }.to_not change(Comment, :count)
    end
  end
end
