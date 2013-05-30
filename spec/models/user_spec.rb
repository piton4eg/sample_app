require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example", email: "example@example.com",
    password: "123456", password_confirmation: "123456") }

  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }


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

  describe "when email address is already exist" do
    before do
      user_double = @user.dup
      user_double.email = @user.email.upcase
      user_double.save
    end

    it { should_not be_valid }
  end

  describe "when password is blank" do
    before do
      @user = User.new(name: "Ivan", email: "ivan@example.com",
        password: "", password_confirmation: "")
    end

    it { should_not be_valid }
  end

  describe "when password confirmation not assigned" do
    before { @user.password_confirmation = "error text" }

    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before do
      @user = User.new(name: "Ivan", email: "ivan@example.com",
        password: "password", password_confirmation: nil)
    end

    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid information" do
      it { should eq found_user.authenticate(@user.password) }      
    end
    describe "with invalid information" do
      let(:invalid_user) { found_user.authenticate("error") }
      it { should_not eq invalid_user }
      specify { expect(invalid_user).to be_false }
    end
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }

    it { should_not be_valid }
  end

  describe "email address with mix case" do
    let(:mix_case_email) { 'Foo@EmaIL.com' }

    it "should be saved as all lower-case" do
      @user.email = mix_case_email
      @user.save
      expect(@user.reload.email).to eq mix_case_email.downcase
    end
  end
end
  