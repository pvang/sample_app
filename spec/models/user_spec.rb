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
  	it { should respond_to(:microposts) } # test for the user’s microposts attribute
  	it { should respond_to(:feed) } # tests for the (proto-)status feed

    it { should respond_to(:admin) } # tests for an admin attribute
    it { should respond_to(:authenticate) } # tests for an admin attribute

    it { should respond_to(:feed) } # tests for the user.relationships attribute
    it { should respond_to(:relationships) } # tests for the user.relationships attribute
    it { should respond_to(:reverse_relationships) } # tests for reverse relationships
    it { should respond_to(:followers) } # tests for reverse relationships
    it { should respond_to(:followed_users) } # test for the user.followed_users attribute
    it { should respond_to(:following?) } # tests for some "following" utility methods
    it { should respond_to(:follow!) } # tests for some "following" utility methods
    it { should respond_to(:unfollow!) } # test for unfollowing a user

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

  	describe "accessible attributes" do # test to verify that the User admin attribute isn’t accessible
    	it "should not allow to access to admin attribute" do
      		expect do
		        User.new(:admin => true)
      		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
	    end
  	end

    describe "remember token" do # test for a valid (non-blank) remember token
      before { @user.save }
      its(:remember_token) { should_not be_blank }
    end

	describe "micropost associations" do # test the order of a user’s microposts

	  before { @user.save }
	  let!(:older_micropost) do 
	    FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
	  end
	  let!(:newer_micropost) do
	    FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
	  end

	  it "should have the right microposts in the right order" do
	    @user.microposts.should == [newer_micropost, older_micropost] # this is the key line that does the trick
	  end

      describe "status" do
        let(:unfollowed_post) do
          FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
        end

	    let(:followed_user) { FactoryGirl.create(:user) }

	    before do
	      @user.follow!(followed_user)
	      3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
	    end

        its(:feed) { should include(newer_micropost) }
        its(:feed) { should include(older_micropost) }
        its(:feed) { should_not include(unfollowed_post) }
        its(:feed) do
          followed_user.microposts.each do |micropost|
            should include(micropost)
          end
        end
      end

      it "should destroy associated microposts" do # tests that microposts are destroyed when users are
        microposts = @user.microposts.dup
        @user.destroy
        microposts.should_not be_empty
        microposts.each do |micropost|
          Micropost.find_by_id(micropost.id).should be_nil
      end
   end

   describe "following" do # tests for some "following" utility methods
     let(:other_user) { FactoryGirl.create(:user) }    
     before do
       @user.save
       @user.follow!(other_user)
     end

     it { should be_following(other_user) }
     its(:followed_users) { should include(other_user) }

     describe "followed user" do # test for reverse relationships
       subject { other_user }
       its(:followers) { should include(@user) }
     end

     describe "and unfollowing" do
       before { @user.unfollow!(other_user) }

       it { should_not be_following(other_user) }
       its(:followed_users) { should_not include(other_user) }
     end
   end
 end
end