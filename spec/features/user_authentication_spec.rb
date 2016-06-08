require 'rails_helper'

feature 'User authentication' do
  background do
    @user = FactoryGirl.create(:user)
  end

  scenario 'can sign up' do
    visit root_path
    expect(page).to have_link('Register')
    click_link 'Register'
    fill_in 'Email', with: "newuser@gmail.com"
    fill_in 'Username', with: "newuser"
    fill_in 'Password', with: "password"
    fill_in 'Confirm Password', with: "password"
    click_button 'Sign up'
    expect(page.current_path).to eq root_path
  end

  scenario 'can log in from the index via dynamic navbar' do
    visit root_path
    expect(page).to_not have_link('New Post')

    click_link 'Login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'

    expect(page).to have_content('Signed in')
    expect(page).to have_link('New Post')
    expect(page).to have_link('Logout')
    expect(page).to_not have_link('Register')
  end

  scenario 'can log out once logged in' do
    log_in_as(@user)
    click_link 'Logout'
    expect(page).to have_link('Login')
  end

  #scenario 'cannot view index posts without logging in' do
    #visit root_path
    #expect(page).to have_content('You need to sign in')
  #end

  scenario 'cannot create a new post without logging in' do
    visit new_post_path
    expect(page).to have_content('You need to sign in')
  end
end
