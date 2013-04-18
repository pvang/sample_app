class Micropost < ActiveRecord::Base
  # attr_accessible :content, :user_id
  attr_accessible :content # making only the content attribute accessible

  belongs_to :user # a micropost belongs_to a user

  validates :content, presence: true, length: { maximum: 140 } # validates length does not exceed 140 characters
  validates :user_id, presence: true # validation for the micropost’s user_id

  default_scope order: 'microposts.created_at DESC' # ordering the microposts with default_scope
end