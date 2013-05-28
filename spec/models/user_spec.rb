require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example", email: "example@example.com") }

  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

  describe "when name is not presence" do
    before { @user.name = '' }

    it { should_not be_valid}
  end
  describe "when email is not presence" do
    before { @user.email = '' }

    it { should_not be_valid}
  end
  describe "when name is too long" do
    before { @user.name = 'a' * 51 }

    it { should_not be_valid }
  end
  describe "when email is incorrect" do
    it "should be incorrect" do
      emails = %w[user@foo,com user_at_foo.org example.user@foo foo@bar_com.org foo@bar+com.org]
      emails.each do |mail|
        @user.email = mail
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email is correct" do
    it "should be correct" do
      emails = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      emails.each do |mail|
        @user.email = mail
        expect(@user).to be_valid
      end
    end
  end
end
