require 'rails_helper'

describe 'notifications/index.html.haml' do
  before(:each) do
    (1..10).each do
      create(:notification, notice_type: "comment")
      create(:notification, notice_type: "like")
    end
    @notifications = Notification.all
    assign(:notifications, @notifications)
  end

  it 'shows notification text and links' do
    render
    @notifications.each do |n|
      expect(rendered).to have_link(notify_text(n), href: link_through_path(n))
    end
  end
end
