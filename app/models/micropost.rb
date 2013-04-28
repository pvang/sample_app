class Micropost < ActiveRecord::Base

  # attr_accessible :content, :user_id
  attr_accessible :content # making only the content attribute accessible

  belongs_to :user # a micropost belongs_to a user

  validates :content, presence: true, length: { maximum: 140 } # validates length does not exceed 140 characters
  validates :user_id, presence: true # validation for the micropost’s user_id

  default_scope order: 'microposts.created_at DESC' # ordering the microposts with default_scope

  def self.from_users_followed_by(user) # returns microposts from the users being followed by the given user
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
                                                user_id: user.id)
  end

end