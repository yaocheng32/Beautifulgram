require 'rails_helper'

describe Notification do
  before(:each) do
    @notification = create(:notification)
  end

  it 'default factory is valid' do
    expect(@notification).to be_valid
  end

  it 'requires user' do
    @notification.user = nil
    expect(@notification).to_not be_valid
  end

  it 'requires notified_by' do
    @notification.notified_by = nil
    expect(@notification).to_not be_valid
  end

  it 'requires post' do
    @notification.post = nil
    expect(@notification).to_not be_valid
  end

  it 'requires identifier' do
    @notification.identifier = nil
    expect(@notification).to_not be_valid
  end

  it 'requires notice_type' do
    @notification.notice_type = ''
    expect(@notification).to_not be_valid
  end
end
