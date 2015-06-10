def set_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin).id)
end

def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user).id)
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(a_user=nil)
  user ||= a_user || Fabricate(:user)
  visit('/sign_in')
  fill_in('email', with: user.email)
  fill_in('password', with: user.password)
  click_button('Login')
end

def sign_out
  visit sign_out_path
end
