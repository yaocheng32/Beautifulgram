class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post
  before_action :owned_comment, only: [:destroy]

  def index
    @comments = @post.comments.order("created_at ASC")

    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      create_notification @post, @comment
      #flash[:success] = "Your comment was saved."
      #redirect_to :back
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    else
      flash.now[:alert] = "Something went wrong."
      redirect_to root_path
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      #flash[:success] = "Your comment was deleted."
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def find_post
      @post = Post.find(params[:post_id])
    end

    def create_notification(post, comment)
      return if post.user.id == current_user.id
      Notification.create(user_id: post.user.id,
                          notified_by_id: current_user.id,
                          post_id: post.id,
                          identifier: comment.id,
                          notice_type: 'comment',
                          read: false)
    end

    def owned_comment
      @comment = Comment.find(params[:id])
      unless @comment.user == current_user
        flash[:alert] = "That doesn't belong to you!"
        redirect_to root_path
      end
    end
end
