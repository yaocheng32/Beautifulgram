class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user

  def follow_user
    if current_user.follow(@user.id)
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def unfollow_user
    if current_user.unfollow(@user.id)
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private
    def get_user
      @user = User.find_by! user_name: params[:user_name]
      unless current_user != @user
        flash[:alert] = "Please do not follow yourself"
        redirect_to root_path
      end
    end
end
