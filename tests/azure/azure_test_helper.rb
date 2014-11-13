
def azure_service
  Fog::Compute[:azure]
end

def vm_attributes
  if Fog.mocking?
    image_name = 'ImageName'
    location = 'West US'
  else
    image = azure_service.images.select{|image| image.os_type == "Linux"}.first
    image_name = image.name
    location = image.locations.split(";").first
  end  
  {
    :image  => image_name,
    :location => location,
    :vm_name => vm_name,
    :vm_user => "foguser",
    :password =>  "ComplexPassword!123"
  }
end

def vm_name
  "fog-test-server"
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

def vm_destroy
  server = azure_service.servers.select { |s| s.vm_name == vm_name }.first
  server.destroy if server
end

at_exit do
  vm_destroy unless Fog.mocking?
end
