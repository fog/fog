module Fog
  module DNS
    class Zerigo
      class Real

        require 'fog/zerigo/parsers/dns/find_hosts'

        # Get list of all the host records that match the FQDN.  If desired, can limit
        # search to a specific zone
        #
        #
        # ==== Parameters
        # * fqdn<~String> - domain to look for
        # * zone_id<~Integer> - if want to limit search to specific zone
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'hosts'<~Hash>
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
        #   * 'status'<~Integer> - 200 indicated success
        #
        def find_hosts(fqdn, zone_id = nil)
          if zone_id.nil?
            #look for matching host across all zones
            request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::DNS::Zerigo::FindHosts.new,
              :path     => "/api/1.1/hosts.xml?fqdn=#{fqdn}"
            )
          else
            #look for hosts in a specific zone
            request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::DNS::Zerigo::FindHosts.new,
              :path     => "/api/1.1/zones/#{zone_id}/hosts.xml?fqdn=#{fqdn}"
            )
          end
        end

      end

      class Mock # :nodoc:all
        def find_hosts(fqdn, zone_id = nil)
          response = Excon::Response.new

          zone = find_by_zone_id(zone_id)
          if zone_id && !zone
            response.status = 404
          else
            hosts = zone ? zone['hosts'].select { |z| z['fqdn'] == fqdn } :
                           self.data[:zones].collect { |z| z['hosts'].find { |h| h['fqdn'] == fqdn } }.compact

            response.status = 200
            response.body = {
              'hosts' => hosts
            }
          end

          response
        end
      end
    end
  end
end
