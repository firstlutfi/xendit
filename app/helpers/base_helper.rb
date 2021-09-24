module BaseHelper
  def parse_currency(string)
    string.gsub(/[^\d]/, '')
  end

  def wait
    Selenium::WebDriver::Wait.new(timeout: 30, interval: 0.5, ignore: Selenium::WebDriver::Error::NoSuchElementError)
  end

  def wait_longer
    Selenium::WebDriver::Wait.new(timeout: 60, interval: 0.5, ignore: Selenium::WebDriver::Error::NoSuchElementError)
  end

  def send_request(method, endpoint, auth, body)
    url = URI(ENV['BASE_URL_API'] + endpoint)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = eval("Net::HTTP::#{method.capitalize}.new(url)") # request = Net::HTTP::Post.new(url)
    request.basic_auth auth, ''
    request['content-type'] = 'application/json'
    request.body = body.to_json unless body.nil?
    response = http.request(request)
    response.body = JSON.parse(response.read_body) unless response.body.blank?
    response.body['created_at'] = Time.now.strftime('%d %b, %Y %I:%M %p')
    response
  end
end
