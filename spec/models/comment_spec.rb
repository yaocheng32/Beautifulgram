require 'rails_helper'

describe Comment do
  before(:each) do
    @comment = create(:comment)
  end

  it 'default factory is valid' do
    expect(@comment).to be_valid
  end

  it 'requires a user' do
    @comment.user = nil
    expect(@comment).to_not be_valid
  end

  it 'requires a post' do
    @comment.post = nil
    expect(@comment).to_not be_valid
  end

  it 'requires content' do
    @comment.content = ''
    expect(@comment).to_not be_valid
  end

  it 'reject too long content' do
    @comment.content = 'c' * 301
    expect(@comment).to_not be_valid
  end


end
