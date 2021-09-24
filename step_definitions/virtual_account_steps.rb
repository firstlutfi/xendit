When 'user generate new secret key using {string}' do |secret_key_details|
  @secret_key = @requirements.secret_key_requirement.load_secret_key(secret_key_details).with_indifferent_access
  @app.xendit_settings_page.load
  wait_longer.until { @app.xendit_settings_page.has_btn_create_new_secret_key? }
  @app.xendit_settings_page.btn_create_new_secret_key.click
  wait.until { @app.xendit_settings_page.has_input_api_key_name? }
  if @secret_key[:secret_key_name].present?
    @app.xendit_settings_page.input_api_key_name.send_keys @secret_key[:secret_key_name]
  end
  case @secret_key[:permission]
  when 'Read'
    @app.xendit_settings_page.btn_permission_read.each(&:click)
  when 'Write'
    @app.xendit_settings_page.btn_permission_write.each(&:click)
  else
    @app.xendit_settings_page.btn_permission_none.each(&:click)
  end
  @app.xendit_settings_page.btn_generate_key.click
  if @app.xendit_settings_page.has_no_txt_alert?
    wait.until { @app.xendit_settings_page.has_input_password? }
    @app.xendit_settings_page.input_password.send_keys @credential[:password]
    @app.xendit_settings_page.btn_confirm_password.click
  end
end

And 'user update secret key using {string}' do |secret_key_details|
  @app.xendit_settings_page.btn_edit_secret_key.last.click
  wait.until { @app.xendit_settings_page.has_btn_apply_changes? }
  @update_secret_key = @requirements.secret_key_requirement.load_secret_key(secret_key_details).with_indifferent_access
  case @update_secret_key[:permission]
  when 'Read'
    @app.xendit_settings_page.btn_permission_read.each(&:click)
  when 'Write'
    @app.xendit_settings_page.btn_permission_write.each(&:click)
  else
    @app.xendit_settings_page.btn_permission_none.each(&:click)
  end
  @app.xendit_settings_page.btn_apply_changes.click
  wait.until { @app.xendit_settings_page.has_input_password? }
  @app.xendit_settings_page.input_password.send_keys @credential[:password]
  @app.xendit_settings_page.btn_confirm_password.click
end

Then 'user validate callback response' do
  @app.xendit_callbacks_page.load
  wait_longer.until { @app.xendit_callbacks_page.has_list_transactions? }
  @app.xendit_callbacks_page.input_search.send_keys @virtual_account_id
  wait_longer.until { @app.xendit_callbacks_page.list_transactions.size.eql? 1 }
  @app.xendit_callbacks_page.list_transactions.first.click
  wait.until { @app.xendit_callbacks_page.has_txt_product_type? }
  trx = DateTime.parse(@app.xendit_callbacks_page.txt_transaction_date.text)
  created_at = DateTime.parse(@response.body['created_at'])
  aggregate_failures('Verifying callback response') do
    expect(@app.xendit_callbacks_page.txt_transaction_status.text).to eql 'Completed'
    expect(@app.xendit_callbacks_page.txt_product_type.text).to eql 'Virtual Account Status'
    # there might be a slight difference in the API request when waiting for response
    # since we cannot see the actual data in DB, therefore we give tolerance of +/- 1 minute
    expect(trx.between?(created_at - 1.minutes, created_at + 1.minutes)).to be true
  end
end

Then 'secret key should be successfully (generated)(updated)' do
  wait.until { @app.xendit_settings_page.has_img_icon_success? }
  if $current_step.include? 'generated'
    expect(page).to have_text 'Success!'
    expect(page).to have_text 'Secret API key successfully created.'
    @secret_key[:key] = @app.xendit_settings_page.txt_secret_key.text
    @app.xendit_settings_page.btn_close_modal.click
    wait.until { @app.xendit_settings_page.has_no_txt_secret_key? }
  else
    expect(page).to have_text 'Changes made'
    expect(page).to have_text 'We’ve saved the changes you made to your API key.'
    @app.xendit_settings_page.btn_close_modal_edit.click
  end
end

Then 'secret key should not be created' do
  aggregate_failures('Asserting UI display') do
    expect(@app.xendit_settings_page.has_txt_alert?).to be true
    expect(@app.xendit_settings_page.txt_alert.text).to eql 'You must select a permission'
  end
end

Then 'user delete the newly created secret key' do
  @app.xendit_settings_page.load if @app.xendit_settings_page.has_no_btn_create_new_secret_key?
  wait_longer.until { @app.xendit_settings_page.has_btn_create_new_secret_key? }
  @app.xendit_settings_page.btn_delete_secret_key.last.click
  wait.until { @app.xendit_settings_page.has_input_password? }
  @app.xendit_settings_page.input_password.send_keys @credential[:password]
  @app.xendit_settings_page.btn_confirm_delete.click
  wait.until { @app.xendit_settings_page.has_img_icon_success? }
end
