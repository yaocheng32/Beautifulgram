class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :owned_notification, only: [:link_through]

  def link_through
    @notification.update read: true
    redirect_to post_path @notification.post
  end

  def index
    @notifications = current_user.notifications
  end

  private
    def owned_notification
      @notification = Notification.find(params[:id])
      unless current_user == @notification.user
        flash[:alert] = "Something went wrong."
        redirect_to root_path
      end
    end
end
