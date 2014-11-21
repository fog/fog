
def azure_service
  Fog::Compute[:azure]
end

def vm_attributes
  image = azure_service.images.select{|image| image.os_type == "Linux"}.first
  location = image.locations.split(";").first

  {
    :image  => image.name,
    :location => location,
    :vm_name => vm_name,
    :vm_user => "foguser",
    :password =>  "ComplexPassword!123",
    :storage_account_name => storage_name
  }
end

def vm_name
  "fog-test-server"
end

def storage_name
  "fogteststorageaccount"
end

def fog_server
  server = azure_service.servers.select { |s| s.vm_name == vm_name }.first
  unless server
    server = azure_service.servers.create(
      vm_attributes
    )
  end
  server
end

def storage_account
  storage = azure_service.storage_accounts.select { |s| s.name == storage_name }.first
  unless storage
    storage = azure_service.storage_accounts.create(
      {:name => storage_name, :location => "West US"}
    )
  end
  azure_service.storage_accounts.get(storage_name)
end

def vm_destroy
  server = azure_service.servers.select { |s| s.vm_name == vm_name }.first
  server.destroy if server
end

def storage_destroy
  storage = azure_service.storage_accounts.select { |s| s.name == storage_name }.first
  storage.destroy if storage
end

at_exit do
  unless Fog.mocking?
    storage_destroy
    vm_destroy
  end
end
