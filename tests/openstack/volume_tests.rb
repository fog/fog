require 'fog/openstack/volume'
require 'fog/openstack/volume_v1'
require 'fog/openstack/volume_v2'

Shindo.tests('Fog::Volume[:openstack]', ['openstack', 'volume']) do

  volume = Fog::Volume[:openstack]

  tests("Volumes collection") do
    %w{ volumes }.each do |collection|
      test("it should respond to #{collection}") { volume.respond_to? collection }
      test("it should respond to #{collection}.all") { eval("volume.#{collection}").respond_to? 'all' }
      # not implemented
      #test("it should respond to #{collection}.get") { eval("volume.#{collection}").respond_to? 'get' }
    end
  end

end
