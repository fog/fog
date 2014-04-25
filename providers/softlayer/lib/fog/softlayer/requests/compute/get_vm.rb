#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#
module Fog
  module Compute
    class Softlayer

      class Mock
        def get_vm(identifier)
          response = Excon::Response.new
          response.body = @virtual_guests.map {|vm| vm if vm['id'] == identifier}.compact.reduce
          response.status = 200
          response
        end

      end

      class Real
        def get_vm(identifier)
          request(:virtual_guest, identifier, :expected => [200, 404], :query => 'objectMask=mask[blockDevices,blockDeviceTemplateGroup.globalIdentifier]')
        end
      end
    end
  end
end
