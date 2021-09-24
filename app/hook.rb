Before do |scenario|
  @app = InitializePages.new
  @requirements = InitializeRequirements.new
  @api_endpoints = InitializeEndpoints.new.parse_endpoint
  @step_list = []
  @count_step = 0
  scenario.test_steps.each { |x| @step_list << x.text unless x.text.include? 'hook' }
  $current_step = @step_list[@count_step]
end

AfterStep do
  @count_step += 1
  $current_step = @step_list[@count_step]
end

After do |scenario|
  scenario_id = scenario.name.split('-')[0].strip
  if scenario.failed?
    Capybara.using_session_with_screenshot(Capybara.session_name.to_s) do
      # screenshots will work and use the correct session
    end
  end

  TestrailHelper.new.update_testrail_result(scenario_id, scenario.status.to_s)
end
