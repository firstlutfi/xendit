When 'user search for {string} in the help section' do |keyword|
  expect(@app.xendit_dashboard_page.has_iframe_help_button?).to be true
  @app.xendit_dashboard_page.iframe_help_button do |frame|
    frame.btn_help.click
  end

  @app.xendit_dashboard_page.iframe_help_section do |frame|
    wait.until { frame.has_input_search? }
    frame.input_search.send_keys keyword
    frame.input_search.send_keys :return
    wait.until { frame.has_text? 'Top results' }
    frame.question.click
  end
end

Then 'validate supported eWallets are {string}' do |ewallets_name|
  @app.xendit_dashboard_page.iframe_help_section do |frame|
    wait.until { frame.has_answer? }
    txt = frame.answer.text
    expect(txt).to include ewallets_name
  end
end
