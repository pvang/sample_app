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

require 'spec_helper'

describe User do
  # pending "add some examples to (or delete) #{__FILE__}"

	# before { @user = User.new(name: "Example User", email: "user@example.com") }
	before do
		@user = User.new(name: "Example User", email: "user@example.com",
						 password: "foobar", password_confirmation: "foobar")
	end

	subject { @user }

	it { should respond_to(:name) } # tests for existence of name
	it { should respond_to(:email) } # tests for existence of email
	it { should respond_to(:password_digest) } # tests for existence of password_digest column
	it { should respond_to(:password) } # test for password attribute
	it { should respond_to(:password_confirmation) } # test for password confirmation attribute

    it { should respond_to(:remember_token) } # test for the remember token

	it { should respond_to(:authenticate) } # test for authenticate method

    it { should respond_to(:admin) } # tests for an admin attribute
    it { should respond_to(:authenticate) } # tests for an admin attribute

	it { should be_valid } # verify that the @user object is initially valid
	it { should_not be_admin }

    describe "with admin attribute set to 'true'" do # tests for an admin attribute
      before do
        @user.save!
        @user.toggle!(:admin) # flip the admin attribute from false to true with toggle
      end

      it { should be_admin }
    end

	describe "when name is not present" do # validates name is not blank
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do # validates max name length
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when email is not present" do # validates email is not blank
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do # validate email address format
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
				foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do # validate email address format
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	describe "when email address is already taken" do # tests and rejects duplicate email addresses
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase # make it insensitive to case
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do # tests password is not blank
		before { @user.password = @user.password_confirmation = " " }
			it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do # tests for matching password and password confirmation
		before { @user.password_confirmation = "mismatch" }
			it { should_not be_valid }
	end

	describe "when password confirmation is nil" do # tests for presence of a password
		before { @user.password_confirmation = nil }
			it { should_not be_valid }
	end

	describe "with a password that's too short" do # tests for password length
		before { @user.password = @user.password_confirmation = "a" * 5 }
			it { should be_invalid }
	end

	describe "return value of authenticate method" do # tests for authenticate method
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do # when valid
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do # when invalid
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

	describe "email address with mixed case" do # test for email downcasing (another method)
		let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

		it "should be saved as all lower-case" do
			@user.email = mixed_case_email
			@user.save
			@user.reload.email.should == mixed_case_email.downcase
		end
	end

    describe "remember token" do # test for a valid (non-blank) remember token
      before { @user.save }
      its(:remember_token) { should_not be_blank }
    end

end