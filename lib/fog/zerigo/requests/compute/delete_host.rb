module Fog
  module Zerigo
    class Compute
      class Real

        # Delete a host record 
        #
        # ==== Parameters
        # * host_id<~Integer> - Id of host record to delete
        #
        # ==== Returns
        # * response<~Excon::Response>: - HTTP status code will be result
        def delete_host(host_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/api/1.1/hosts/#{host_id}.xml"
          )
        end

      end

      class Mock

        def delete_host(host_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
