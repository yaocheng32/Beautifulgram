module NotificationsHelper
  def notify_text(notification)
    action = notification.notice_type == "comment" ? "commented on" : "liked"
    "#{notification.notified_by.user_name} #{action} your post"
  end
end
