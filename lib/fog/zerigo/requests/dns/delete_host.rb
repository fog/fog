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

      class Mock # :nodoc:all
        def delete_host(host_id)
          host = find_host(host_id)

          response = Excon::Response.new

          if host
            zone = find_by_zone_id(host['zone-id'])
            zone['hosts'].delete(host)

            response.status = 200
          else
            response.status = 404
          end

          response
        end
      end
    end
  end
end
