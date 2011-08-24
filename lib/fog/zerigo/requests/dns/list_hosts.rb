module Fog
  module DNS
    class Zerigo
      class Real

        require 'fog/zerigo/parsers/dns/list_hosts'

        # Get list of all DNS zones hosted on Slicehost (for this account)
        #
        # ==== Parameters
        # * zone_id<~Integer> - the zone ID of the zone from which to get the host records for
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'hosts'<~Array>
        #       * 'created-at'<~String>
        #       * 'data'<~String>
        #       * 'fqdn'<~String>
        #       * 'host-type'<~String>
        #       * 'hostname'<~String>
        #       * 'id'<~Integer>
        #       * 'notes'<~String>
        #       * 'priority'<~Integer>
        #       * 'ttl'<~Integer>
        #       * 'updated-at'<~String>
        #       * 'zone-id'<~String>
        # * 'status'<~Integer> - 200 indicates success
        def list_hosts( zone_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Zerigo::ListHosts.new,
            :path     => "/api/1.1/zones/#{zone_id}/hosts.xml"
          )
        end

      end
    end
  end
end
