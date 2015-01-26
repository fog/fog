module Fog
  module DNS
    class Zerigo
      class Real
        require 'fog/zerigo/parsers/dns/list_zones'

        # Get list of all DNS zones hosted on Slicehost (for this account)
        #
        # ==== Parameters
        # * options<~Hash>
        #   * page<~Integer> - Indicates where to begin in your list of zones.
        #   * per_page<~Integer> - The maximum number of zones to be included in the response body
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'zones'<~Array>
        #       * 'default-ttl'<~Integer>
        #       * 'id'<~Integer>
        #       * 'nx-ttl'<~Integer>
        #       * 'hosts-count'<~Integer>
        #       * 'created-at'<~String>
        #       * 'custom-nameservers'<~String>
        #       * 'custom-ns'<~String>
        #       * 'domain'<~String>
        #       * 'hostmaster'<~String>
        #       * 'notes'<~String>
        #       * 'ns1'<~String>
        #       * 'ns-type'<~String>
        #       * 'slave-nameservers'<~String>
        #       * 'tag-list'<~String>
        #       * 'updated-at'<~String>
        #       * 'hosts'<~String>
        #       * 'axfr-ips'<~String>
        #       * 'restrict-axfr'<~String>
        #   * 'status'<~Integer> - 200 indicates success
        def list_zones(options = {})
          request(
            :query => options,
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Zerigo::ListZones.new,
            :path     => '/api/1.1/zones.xml'
          )
        end
      end

      class Mock # :nodoc:all
        def list_zones
          response = Excon::Response.new

          response.status = 200
          response.body = {
            'zones' => self.data[:zones]
          }

          response
        end
      end
    end
  end
end
