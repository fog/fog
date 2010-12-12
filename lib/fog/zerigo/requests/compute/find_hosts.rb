module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/find_hosts'

        # Get list of all DNS zones hosted on Slicehost (for this account)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'origin'<~String> - domain name to host (ie example.com)
        #     * 'id'<~Integer> - Id of the zone
        #     * 'ttl'<~Integer> - TimeToLive (ttl) for the domain, in seconds (> 60)
        #     * 'active'<~String> - whether zone is active in Slicehost DNS server - 'Y' or 'N'
        def find_hosts( fqdn, zone_id = nil)
          if zone_id.nil?
            #look for matching host across all zones
            request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::Zerigo::Compute::FindHosts.new,
              :path     => "/api/1.1/hosts.xml"
            )
          else
            #look for hosts in a specific zone
            request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::Zerigo::Compute::FindHosts.new,
              :path     => "/api/1.1/zones/#{zone_id}/hosts.xml"
            )
          end
        end

      end

      class Mock

        def find_hosts( fqdn, zone_id = nil)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
