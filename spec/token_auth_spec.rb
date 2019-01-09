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
  it "generate secure tokens (50 attempts)" do
    fuzz_list =[]
    (1...50).each do
      fuzz_list << SecureRandom.urlsafe_base64(20)
    end
    fuzz_list.each do |token|
      token = SecureRandom.urlsafe_base64(20)
      expect(token.length).to be > 20
      checker = StrongPassword::StrengthChecker.new(token)
      expect(checker.is_strong?).to be true 
      expect(checker.calculate_entropy(use_dictionary: true)).to be > 24
    end
  end

end