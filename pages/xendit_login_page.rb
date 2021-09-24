class XenditLoginPage < SitePrism::Page
  set_url 'login'

  element :input_email, 'input[type=text]'
  element :input_password, 'input[type=password]'
  element :btn_login, '.btn.btn-primary.btn-md'
  element :btn_forgot_password, '.login-forgot-password'
end
