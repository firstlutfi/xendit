class LoginRequirement
  def initialize
    @db = YAML.load_file './app/configs/credentials.yml'
  end

  def load_credential(user_details)
    @db[user_details]
  end
end
