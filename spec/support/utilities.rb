def sign_in(user)
  # Capybara
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button("Sign in")
  # PUT request
  cookies[:remember_token] = user.remember_token
end
