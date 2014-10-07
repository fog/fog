module Fog
  module DNS
    class Zerigo
      class Real
        require "fog/zerigo/parsers/dns/list_hosts"

        # Get list of all DNS zones hosted on Slicehost (for this account)
        #
        # ==== Parameters
        # * zone_id<~Integer> - the zone ID of the zone from which to get the host records for
        # * 'options'<~Hash> - optional parameters
        #   * 'page' <~Integer>
        #   * 'per_page' <~Integer>
        #   * 'fqdn' <~String>
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
        def list_hosts(zone_id, options={})
          request(
            :query    => options,
            :expects  => 200,
            :method   => "GET",
            :parser   => Fog::Parsers::DNS::Zerigo::ListHosts.new,
            :path     => "/api/1.1/zones/#{zone_id}/hosts.xml"
          )
        end
      end

      class Mock # :nodoc:all
        def list_hosts(zone_id, options={})
          zone = find_by_zone_id(zone_id)

          response = Excon::Response.new

          if zone
            if options.empty?
              response.status = 200
              response.body = {
                "hosts" => zone["hosts"]
              }
            else
              hosts = zone["hosts"]
              hosts = hosts.select {|h| h["fqdn"] == options["fqdn"]} if options["fqdn"]
              hosts = options["per_page"] ? hosts.each_slice(options["per_page"] - 1).to_a : hosts.each_slice(100).to_a
              hosts = options["page"] ? hosts[options["page"]] : hosts[0]
              response.status = 200
              response.body = {
                "hosts" => hosts
              }
            end
          else
            response.status = 404
          end

          response
        end
      end
    end
  end
end
