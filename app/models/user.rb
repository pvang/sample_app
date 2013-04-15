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

  # ensures email uniqueness by downcasing the email attribute
  before_save { |user| user.email = email.downcase }

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
  validates :password, presence: true, length: { minimum: 6 }
  # validates presence of a confirmation password
  validates :password_confirmation, presence: true

end