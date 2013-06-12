require 'spec_helper'

describe "Static pages" do
	subject { page }

  describe "Home page" do
  	before { visit root_path }
    
    it {should have_content('Sample App')}
    it {should have_title(full_title(''))}

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end

  describe "Help page" do
  	before { visit help_path }

    it {should have_content('Help')}
    it {should have_title(full_title('Help'))}
  end

  describe "About page" do
  	before { visit about_path }

    it {should have_content('About Us')}
    it {should have_title(full_title("About Us"))}
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end