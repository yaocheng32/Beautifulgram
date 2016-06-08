require 'rails_helper'

describe PostsController do
  before(:each) do
    @user = create(:user)
    @post = create(:post, user: @user)
    @user1 = @user
    @post1 = @post
    @user2 = create(:user)
    @post2 = create(:post, user: @user2)
    @user3 = create(:user)
    @post3 = create(:post, user: @user3)
    @user1.follow(@user2.id)
    sign_in @user
  end

  describe 'GET #index' do
    before(:each) { get :index }

    it 'requires login' do
      sign_out @user
      get :index
      expect(response).to redirect_to new_user_session_path
    end

    it 'assigns posts' do
      posts = assigns(:posts)
      expect(posts).to include(@post1)
      expect(posts).to include(@post2)
      expect(posts).to_not include(@post3)
    end

    it 'renders the :index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'requires login' do
      sign_out @user
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'renders the :new view' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    it 'requires login' do
      sign_out @user
      post :create
      expect(response).to redirect_to new_user_session_path
    end

    context 'with valid attributes' do
      it 'creates a new post' do
        expect {
          post :create, post: attributes_for(:post)
        }.to change(Post, :count).by(1)
      end

      it 'redirects to index' do
        post :create, post: attributes_for(:post)
        expect(response).to redirect_to(posts_path)
      end
    end

    context 'with invalid attributes' do
      it 'cannot create a new post' do
        expect {
          post :create, post: attributes_for(:invalid_post)
        }.to_not change(Post, :count)
      end

      it 'renders :new' do
        post :create, post: attributes_for(:invalid_post)
        expect(response).to render_template(:new)
      end
    end

  end

  describe 'GET #show' do
    before(:each) { get :show, id: @post }

    it 'requires login' do
      sign_out @user
      get :show, id: @post.id
      expect(response).to redirect_to new_user_session_path
    end

    it 'assigns post' do
      expect(assigns(:post)).to eq @post
    end

    it 'renders :show' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    before(:each) { get :edit, id: @post }

    it 'requires login' do
      sign_out @user
      get :edit, id: @post.id
      expect(response).to redirect_to new_user_session_path
    end

    it 'assigns post' do
      expect(assigns(:post)).to eq @post
    end

    it 'renders :edit' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    it 'requires login' do
      sign_out @user
      patch :update, id: @post.id
      expect(response).to redirect_to new_user_session_path
    end

    context 'with valid attributes' do
      it 'assigns the post' do
        patch :update, id: @post, post: attributes_for(:post)
        expect(assigns(:post)).to eq @post
      end

      it 'updates the post' do
        cap = 'new caption'
        img = Rack::Test::UploadedFile.new(Rails.root + 'spec/files/images/posts/image1.png', 'image/png')
        filename = img.original_filename
        patch :update, id: @post, post: attributes_for(:post, caption: cap, image: img)
        @post.reload
        expect(@post.caption).to eq cap
        expect(@post.image_file_name).to eq filename

        img = nil
        patch :update, id: @post, post: attributes_for(:post, caption: cap, image: img)
        @post.reload
        expect(@post.caption).to eq cap
        expect(@post.image_file_name).to eq filename
      end
    end

    context 'with invalid attributes' do
      it 'does not updates the post' do
        cap = ''
        img = Rack::Test::UploadedFile.new(Rails.root + 'spec/files/images/posts/image1.png', 'image/png')
        patch :update, id: @post, post: attributes_for(:post, caption: cap, image: img)
        @post.reload
        expect(@post.caption).to_not eq cap
        expect(@post.image_file_name).to_not eq 'image1.png'
      end
      it 'renders :edit' do
        cap = ''
        img = Rack::Test::UploadedFile.new(Rails.root + 'spec/files/images/posts/image1.png', 'image/png')
        patch :update, id: @post, post: attributes_for(:post, caption: cap, image: img)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'requires login' do
      sign_out @user
      delete :destroy, id: @post.id
      expect(response).to redirect_to new_user_session_path
    end

    it 'deletes the post' do
      expect {
        delete :destroy, id: @post
      }.to change(Post, :count).by(-1)
    end

    it "cannot delete other's post" do
      expect {
        delete :destroy, id: @post2
      }.to_not change(Post, :count)
    end

    it 'redirects to :index' do
      delete :destroy, id: @post
      expect(response).to redirect_to posts_path
    end
  end

  describe 'GET #like' do
    before(:each) { request.env['HTTP_REFERER'] = posts_path }

    it 'requires login' do
      sign_out @user
      get :like, id: @post.id
      expect(response).to redirect_to new_user_session_path
    end

    it 'makes the user like the post' do
      get :like, id: @post
      expect(@user.voted_up_on? @post).to be true
    end

    it 'creates a new notification' do
      expect {
        get :like, id: @post2
      }.to change(Notification, :count).by(1)
    end

    it 'does not create a new notification when liking my own post' do
      expect {
        get :like, id: @post
      }.to_not change(Notification, :count)
    end
  end

  describe 'GET #unlike' do
    before(:each) do
      request.env['HTTP_REFERER'] = posts_path
      get :like, id: @post2
    end

    it 'requires login' do
      sign_out @user
      get :unlike, id: @post.id
      expect(response).to redirect_to new_user_session_path
    end

    it 'makes the user unlike the post' do
      expect(@user.voted_up_on? @post2).to be true
      get :unlike, id: @post2
      expect(@user.voted_up_on? @post2).to be false
    end

    it 'does not create a new notification' do
      expect {
        get :unlike, id: @post2
      }.to_not change(Notification, :count)
    end
  end

  describe 'GET #browse' do
    it 'requires login' do
      sign_out @user
      get :browse
      expect(response).to redirect_to new_user_session_path
    end

    it 'assigns all posts with page' do
      get :browse, page: 1
      Post.all.page(1).each do |post|
        expect(assigns(:posts)).to include(post)
      end
      get :browse, page: 2
      Post.all.page(2).each do |post|
        expect(assigns(:posts)).to include(post)
      end
    end
  end
end
