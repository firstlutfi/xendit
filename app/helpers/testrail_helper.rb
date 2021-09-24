# rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Style/GuardClause
class TestrailHelper
  attr_reader :file_name, :test_rail_file
  attr_accessor :error_log_update_runs, :error_log_automated_status

  def initialize
    @file_name = "#{Dir.pwd}/app/configs/testrail.yml"
    @test_rail_file = YAML.load_file(@file_name)
    @error_log_update_runs = []
    @error_log_automated_status = []
  end

  def update_testrail_result(case_ids, status)
    coll_case_ids = sanitize_test_case_id case_ids
    run_results = parse_status coll_case_ids, status
    if status.empty? || status.nil? || case_ids.to_s.strip.empty? || status.to_s.strip.empty?
      p 'Specified parameters is not correct, please re-check !'
    else
      update_automated_status coll_case_ids
      update_test_run run_results

      if !@error_log_automated_status.empty? || !@error_log_update_runs.empty?
        p 'Failed updating result to testrail!!!'
        p "Error log automated status: #{@error_log_automated_status}"
        p "Error log test run result: #{@error_log_update_runs}"
      else
        p "Test case #{coll_case_ids} successfully updated in Testrail"
      end
    end
  rescue Exception => e
    p "Error Occured in Test Rail Integration, Error Desc is : #{e.message}"
  end

  private

  def update_automated_status(case_ids)
    automated = { 'custom_automated' => 1 }
    case_ids.each do |id| # updating automated status to testrail needs to be one by one
      automated_status_uri = "update_case/#{id}"
      update_automated_status = update_to_testrail(@test_rail_file, automated_status_uri, automated)
      if update_automated_status.code.to_i != 200 && update_automated.body['error'].present?
        @error_log_automated_status << update_automated.body['error']
      end
    end
  end

  def update_test_run(results)
    add_results_uri = 'add_results_for_cases/1'
    update_run = update_to_testrail(@test_rail_file, add_results_uri, results)
    if update_run.code.to_i != 200 && update_run.body['error'].present?
      @error_log_update_runs << update_run.body['error']
    end
  end

  def update_to_testrail(credential, endpoint, request_body = nil)
    url = URI(credential['url'].to_s + endpoint)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(url)
    request.basic_auth credential['email'], credential['password']
    request['content-type'] = 'application/json'
    request.body = request_body.to_json unless request_body.nil?
    response = http.request(request)
    response.body = JSON.parse(response.read_body) unless response.body.blank?

    response
  end

  def sanitize_test_case_id(test_case_ids)
    filtered_test_case = test_case_ids.split(',')
    filtered_test_case.collect { |test_case| test_case.gsub!(/C/, '').to_i }
  end

  def parse_status(case_ids, status)
    temp = { results: [] }
    case_ids.each do |id|
      if status.casecmp('passed').zero?
        status_id = 1
        comment = 'This scenarios marked as PASSED'
      elsif status.casecmp('failed').zero?
        status_id = 5
        comment = 'This scenarios marked as FAILED'
      end
      temp[:results] << { case_id: id, status_id: status_id, comment: comment }
    end

    temp
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Style/GuardClause
