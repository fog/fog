module Fog
  module Compute
    class HPV2
      class Real
        # Release an existing floating IP address
        #
        # ==== Parameters
        # * 'address_id'<~String> - UUId of floating IP address to release
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
          else
            raise Fog::Compute::HPV2::NotFound
          end
          response
        end
      end
    end
  end
end
