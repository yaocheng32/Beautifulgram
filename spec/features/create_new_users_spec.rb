require 'rails_helper'

feature 'Create new users' do
  background do
    visit root_path
    click_link 'Register'
  end

  scenario 'can create a new user via the index page' do
    fill_in 'Username', with: 'hello'
    fill_in 'Email', with: 'hello@gmail.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content('Welcome!')
  end

  scenario 'requires a user name to successfully create an account' do
    fill_in 'Email', with: 'hello@gmail.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content('blank')
  end

  scenario 'requires a user name to be more than 4 characters' do
    fill_in 'Username', with: 'h'
    fill_in 'Email', with: 'hello@gmail.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content('minimum')
  end

  scenario 'requires a user name to be less than 16 characters' do
    fill_in 'Username', with: 'h'*500
    fill_in 'Email', with: 'hello@gmail.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content('maximum')
  end
end
