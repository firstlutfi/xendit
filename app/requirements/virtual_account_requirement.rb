class VirtualAccountRequirement
  DataMagic.load 'create_virtual_account.yml'

  def load_virtual_account(key)
    data_for "create_virtual_account/#{key}"
  end
end
