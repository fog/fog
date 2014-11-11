
def service
  Fog::Compute[:azure]
end

def fog_test_server_attributes
  image = service.images.select{|image| image.os_type == 'Linux'}.first
  location = image.locations.split(';').first
  {
    :image  => image.name,
    :location => location,
    :vm_name => vm_name,
    :vm_user => 'foguser',
    :password =>  'ComplexPassword!123'
  }
end

def vm_name
  "fog-test-server"
end

def fog_test_server
  server = service.servers.select { |s| s.vm_name == vm_name }.first
  unless server
    server = service.servers.create(
      fog_test_server_attributes
    )
  end
  server
end

def fog_test_server_destroy
  server = service.servers.select { |s| s.vm_name == vm_name }.first
  server.destroy if server
end

at_exit do
  fog_test_server_destroy unless Fog.mocking?
end
