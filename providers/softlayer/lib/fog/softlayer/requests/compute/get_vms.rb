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
        def get_vms
          response = Excon::Response.new
          response.body = @virtual_guests
          response.status = 200
          response
        end

      end

      class Real
        def get_vms
          request(:account, :get_virtual_guests)
        end
      end
    end
  end
end
