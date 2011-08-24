module Fog
  module DNS
    class Zerigo
      class Real

        require 'fog/zerigo/parsers/dns/get_zone'

        # Get details of a DNS zone. The response is similar to list_zones, with the 
        # addition of hosts-count and possibly hosts.
        #
        # ==== Parameters
        # * zone<~String> - Either the zone ID or the zone name (ie sample-domain.com)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'default-ttl'<~Integer>
        #     * 'id'<~Integer>
        #     * 'nx-ttl'<~Integer>
        #     * 'hosts-count'<~Integer>
        #     * 'created-at'<~String>
        #     * 'custom-nameservers'<~String>
        #     * 'custom-ns'<~String>
        #     * 'domain'<~String>
        #     * 'hostmaster'<~String>
        #     * 'notes'<~String>
        #     * 'ns1'<~String>
        #     * 'ns-type'<~String>
        #     * 'slave-nameservers'<~String>
        #     * 'tag-list'<~String>
        #     * 'updated-at'<~String>
        #     * 'hosts'<~Array> - a list of all host records. For the format of host info, see get_host() 
        #     * 'axfr-ips'<~String>
        #     * 'restrict-axfr'<~String>    
        #   * 'status'<~Integer> - 200 indicates success
        
        def get_zone(zone)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Zerigo::GetZone.new,
            :path     => "/api/1.1/zones/#{zone}.xml"
          )
        end

      end
    end
  end
end
