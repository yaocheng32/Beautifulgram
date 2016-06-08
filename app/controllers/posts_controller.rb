class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:gallery, :fake_gallery]
  before_action :find_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :owned_post, only: [:edit, :update, :destroy]

  def index
    @posts = current_user.feed.order("created_at DESC").page(params[:page])
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post has been created."
      redirect_to posts_path
    else
      flash.now[:alert] = "Post can't be created."
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Post has been updated."
      redirect_to @post
    else
      flash.now[:alert] = "Post can't be updated."
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post has been deleted."
    redirect_to posts_path
  end

  def like
    if @post.liked_by current_user
      create_notification(@post)
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def unlike
    if @post.unliked_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def browse
    @posts = Post.all.order('created_at DESC').page params[:page]
  end

  def gallery
    @posts = Post.all.order('created_at DESC').page(params[:page]).per(20)
  end

  # To deal with kaminari bug
  def fake_gallery
    redirect_to gallery_path
  end

  private
    def post_params
      params.require(:post).permit(:caption, :image)
    end

    def find_post
      @post = Post.find(params[:id])
    end

    def owned_post
      unless current_user == Post.find(params[:id]).user
        flash[:alert] = "That post doesn't belong to you!"
        redirect_to root_path
      end
    end

    def create_notification(post)
      return if post.user.id == current_user.id
      Notification.create(user_id: post.user.id,
                          notified_by_id: current_user.id,
                          post_id: post.id,
                          identifier: post.id,
                          notice_type: 'like',
                          read: false)
    end
end
