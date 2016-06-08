require 'rails_helper'

describe Post do
  before(:each) do
    @post = create(:post)
  end

  it 'default factory is valid' do
    expect(@post).to be_valid
  end

  it 'requires image' do
    @post.image = nil
    expect(@post).to_not be_valid
  end

  it 'requires image to be image file' do
    @post.image = File.new('spec/files/others/test.txt')
    expect(@post).to_not be_valid
  end

  it 'requires caption' do
    @post.caption = ''
    expect(@post).to_not be_valid
  end

  it 'reject too long caption' do
    @post.caption = 'c' * 301
    expect(@post).to_not be_valid
  end

  it 'requires user' do
    @post.user = nil
    expect(@post).to_not be_valid
  end
end
