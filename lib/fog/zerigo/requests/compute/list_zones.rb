module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/list_zones'

        # Get list of all DNS zones hosted on Slicehost (for this account)
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
        def list_zones
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Zerigo::Compute::ListZones.new,
            :path     => '/api/1.1/zones.xml'
          )
        end

      end

      class Mock

        def list_zones
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
