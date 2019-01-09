require 'rails_helper'
require 'spec_helper'
require 'capybara/rspec'


RSpec.describe "Email token auth layer", :type => :feature do
  it 'authenticates at the right root path' do
    visit('https://young-lowlands-69353.herokuapp.com/')
    expect(page.title).to have_content("Welcome to TAnder!")
  end
  it 'brute force attack for login token (100 attempts)' do
    fuzz_list =[]
    (1...100).each do
      fuzz_list << SecureRandom.urlsafe_base64(20)
    end
    fuzz_list.each do |fuzz|
      visit("https://young-lowlands-69353.herokuapp.com/auth?#{fuzz}")
      expect(page).to have_content("It seems your link is invalid. Try requesting for a new login link")
    end  
  end
  it 'contains a decent token validity period' do
    test = User.new
    expect(test.instance_variable_get(token_validity)).to be <= 24.hour
    expect(test.instance_variable_get(token_validity)).to be >= 15.minute
  end
  it "generates a secure enough token" do
    test = User.new
    token = test.generate_login_token
    expect(token.length).to be > 20
    checker = StrongPassword::StrengthChecker.new(token)
    expect(checker.is_strong?).to be true 
    expect(checker.calculate_entropy(use_dictionary: true)).to be > 33
  end

end