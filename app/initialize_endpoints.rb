class InitializeEndpoints
  FILE_PATH = './app/configs/api_endpoints.yml'.freeze

  def parse_endpoint
    YAML.load_file(FILE_PATH)
  end
end
