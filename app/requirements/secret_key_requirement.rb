class SecretKeyRequirement
  DataMagic.load 'create_secret_key.yml'

  def load_secret_key(key)
    data_for "create_secret_key/#{key}"
  end
end
