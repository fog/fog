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

        # Delete a VM
        # @param [Integer] id
        # @return [Excon::Response]
        def delete_vm(id)
          response = Excon::Response.new

          # Found it and deleted it.
          response.status = 200
          response.body = self.get_vms.body.map{|server| server['id']}.include?(id)

          # Didn't find it, give the error that the API would give.
          unless response.body
            response.body = Fog::JSON.encode({:error => "A billing item is required to process a cancellation.", :code => "SoftLayer_Exception_NotFound"})
            response.status = 500
          end

          response
        end
      end

      class Real

        def delete_vm(id)
          request(:virtual_guest, id.to_s, :http_method => :DELETE)
        end

      end
    end
  end
end
