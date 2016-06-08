# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User.create(user_name:, email:)

require 'faker'

# My test machine here
testMachine = User.create(user_name: 'testMachine',
                          email: 'test@gmail.com',
                          password: '12345678',
                          bio: 'I see you!')

# Creates 50 users
(1..50).each do |i|
  user = User.create(user_name: "#{Faker::App.name}#{i}".gsub(/\s+/, ""),
                     email: Faker::Internet.email,
                     password: 'password',
                     avatar: File.new(Rails.root + "spec/files/images/avatars/image#{i}.png"))#avatar: Rack::Test::UploadedFile.new(Rails.root + "spec/files/images/avatars/image#{i}.png", "image/png"))
end

# Creates 200 posts
(1..200).each do |i|
  user = User.offset(rand(User.count)).first
  Post.create(user: user,
              caption: Faker::Book.title,
              image: File.new(Rails.root + "spec/files/images/posts/image#{i}.png"))#image: Rack::Test::UploadedFile.new(Rails.root + "spec/files/images/posts/image#{i}.png", "image/png"))
end

# Let testMachine follow 10 users
User.offset(rand(User.count)).limit(10).each do |u|
  testMachine.follow(u.id) unless testMachine == u
end

# Generate comments
800.times do
  user = User.offset(rand(User.count)).first
  post = Post.offset(rand(Post.count)).first
  Comment.create(user: user,
                 post: post,
                 content: Faker::StarWars.quote)
end

# Randomly like posts
1000.times do
  user = User.offset(rand(User.count)).first
  post = Post.offset(rand(Post.count)).first
  post.liked_by user
end

# Randomly follow users
500.times do
  user1 = User.offset(rand(User.count)).first
  user2 = User.offset(rand(User.count)).first
  user1.follow(user2.id) if user1 != user2 && !user1.followings.include?(user2)
end
