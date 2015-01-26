module Fog
  module Compute
    class HP
      class Real
        # Release an existing floating IP address
        #
        # ==== Parameters
        # * id<~Integer> - Id of floating IP address to delete
        #
        def release_address(address_id)
          request(
            :expects => 202,
            :method => 'DELETE',
            :path   => "os-floating-ips/#{address_id}"
          )
        end
      end

      class Mock
        def release_address(address_id)
          response = Excon::Response.new
          if self.data[:addresses][address_id]
            self.data[:last_modified][:addresses].delete(address_id)
            self.data[:addresses].delete(address_id)
            response.status = 202
            response.body = "202 Accepted\n\nThe request is accepted for processing.\n\n   "
          else
            raise Fog::Compute::HP::NotFound
          end
          response
        end
      end
    end
  end
end
