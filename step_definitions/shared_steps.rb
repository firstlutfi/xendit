Given 'user login using {string}' do |user_detail|
  @credential = @requirements.login_requirement.load_credential(user_detail).with_indifferent_access
  visit '/'
  wait_longer.until { @app.xendit_dashboard_page.has_txt_title? || @app.xendit_login_page.has_btn_login? }
  if @app.xendit_login_page.has_btn_login?
    @app.xendit_login_page.input_email.send_keys @credential[:email]
    @app.xendit_login_page.input_password.send_keys @credential[:password]
    @app.xendit_login_page.btn_login.click
    wait_longer.until { @app.xendit_dashboard_page.has_txt_title? }
  elsif @app.xendit_dashboard_page.has_txt_title?
    p "User already login using #{@credential[:email]}"
  end
end

When 'user send {string} request to {string} using {string}' do |method, endpoint, request_body|
  @body = @requirements.virtual_account_requirement.load_virtual_account(request_body).with_indifferent_access
  @response = send_request(method, @api_endpoints[endpoint], @secret_key[:key], @body)
end

Then 'API response should return {int}' do |response_code|
  expect(@response.code.to_i).to eql response_code
  if response_code.eql? 200
    aggregate_failures('Verifying API response') do
      expect(@response.body['bank_code']).to eql @body[:bank_code]
      expect(@response.body['name']).to include @body[:name]
      expect(@response.body['external_id']).to eql @body[:external_id]
    end
    @virtual_account_id = @response.body['id']
  else
    expect(@response.body['message']).to eql @body['error_message']
    if @response.body['errors'].present?
      expect(@response.body['errors'][0]['messages'][0]).to include @body['error_detail']
    end
  end
end
