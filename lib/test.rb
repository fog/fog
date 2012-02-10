require './fog'
c = Fog::Compute.new(:provider => "Joyent",
                     :cloudapi_url => "https://10.99.99.26",
                     :cloudapi_username => "admin",
                     :cloudapi_password => "joypass123")
puts c.servers.inspect
puts c.keys.inspect
puts c.images.inspect
puts c.flavors.inspect
