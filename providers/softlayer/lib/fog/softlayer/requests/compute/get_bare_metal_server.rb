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
        def get_bare_metal_server(identifier)
          response = Excon::Response.new
          response.body = @bare_metal_servers.map {|vm| vm if vm['id'] == identifier}.compact.reduce
          response.status = 200
          response
        end

      end

      class Real
        def get_bare_metal_server(identifier)
          request(:hardware_server, identifier, :expected => [200, 404], :query => 'objectMask=mask[memory,provisionDate,processorCoreAmount,hardDrives,datacenter,hourlyBillingFlag]')
        end
      end
    end
  end
end
