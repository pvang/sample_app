# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  # attr_accessible(:name, :email)
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy # a user has_many microposts and their microposts are destroyed along with them when they are
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy # implementing the user/relationships has_many association
  has_many :followed_users, through: :relationships, source: :followed # adding the User model followed_users association
  has_many :reverse_relationships, foreign_key: "followed_id", # implementing user.followers using reverse relationships
                                    class_name: "Relationship",
                                     dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower # implementing user.followers using reverse relationships

  # ensures email uniqueness by downcasing the email attribute
  before_save { |user| user.email = email.downcase } # this works
  # before_save { self.email.downcase! } # so does this

  before_save :create_remember_token # a before_save callback to create remember_token

  # name cannot be blank
  # name characters cannot exceed 50
  # validates(:name, presence: true)
  validates :name, presence: true, length: { maximum: 50 }

  # validates(:email, presence: true)
  # email cannot be blank
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
					# uniqueness: true # tests for email uniqueness
          uniqueness: { case_sensitive: false } # tests for email uniqueness (not sensitive to case)

  # validates presence of a password and its length
  # validates :password, presence: true, length: { minimum: 6 }
  validates :password, length: { minimum: 6 } # changed from the one above to avoid duplication of error messages because we added the hack for a better error message for missing passwords
  # validates presence of a confirmation password
  validates :password_confirmation, presence: true

  def feed # preliminary implementation for the micropost status feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.from_users_followed_by(self) # Micropost.where("user_id = ?", id)
  end

  def following?(other_user) # following? utility method
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user) # follow! utility method
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user) # unfollowing a user by destroying a user relationship
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end