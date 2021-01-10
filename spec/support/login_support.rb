module LoginSupport
  def login_as(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'foobar'
    click_button 'Login'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end