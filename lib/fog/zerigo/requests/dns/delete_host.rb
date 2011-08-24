module Fog
  module DNS
    class Zerigo
      class Real

        # Delete a host record 
        #
        # ==== Parameters
        # * host_id<~Integer> - Id of host record to delete
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * 'status'<~Integer> - 200 indicates success
        def delete_host(host_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/api/1.1/hosts/#{host_id}.xml"
          )
        end

      end
    end
  end
end
