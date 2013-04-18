require 'spec_helper'

describe Micropost do # initial micropost spec
  # pending "add some examples to (or delete) #{__FILE__}"

  let(:user) { FactoryGirl.create(:user) }
  # before do # This code is wrong!
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
  # end
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user } # tests for the micropost’s user association

  it { should be_valid }

  describe "when user_id is not present" do # tests for the presence of the user_id attribute
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do # micropost model validation (blank)
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do # micropost model validation (length)
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end

  describe "accessible attributes" do # test to ensure that the user_id isn’t accessible
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

end