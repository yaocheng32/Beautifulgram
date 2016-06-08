class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Like
  acts_as_voter

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # This is Wrong
  #has_many :follows
  #has_many :followings, through: 'follows', foreign_key: 'follower_id'
  #has_many :followers, through: 'follows', foreign_key: 'following_id'

  # Follows
  has_many :following_relationships, class_name: 'Follow',
                                     foreign_key: :follower_id,
                                     dependent: :destroy
  has_many :followings, through: :following_relationships, source: :following

  has_many :follower_relationships, class_name: 'Follow',
                                     foreign_key: :following_id,
                                     dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  # Profile image
  has_attached_file :avatar, styles: { medium: '152x152#' }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  validates :user_name, presence: true, length: { minimum: 4, maximum: 16 }, uniqueness: true

  def follow(user_id)
    following_relationships.create(following_id: user_id)
  end

  def unfollow(user_id)
    following_relationships.find_by(following_id: user_id).destroy
  end

  # Returns user's post feed
  def feed
    following_ids = "SELECT following_id FROM follows
                     WHERE  follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

end
