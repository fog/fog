module Fog
  module Zerigo
    class DNS
      class Real

        require 'fog/dns/parsers/zerigo/get_host'

        # get details about a given host record
        #
        # ==== Parameters
        # * host_id<~Integer> - ID of the host record to retrieve
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * body<~Hash>:
        #     * 'created-at'<~String>
        #     * 'data'<~String>
        #     * 'fqdn'<~String>
        #     * 'host-type'<~String>
        #     * 'hostname'<~String>
        #     * 'id'<~Integer>
        #     * 'notes'<~String>
        #     * 'priority'<~Integer>
        #     * 'ttl'<~Integer>
        #     * 'updated-at'<~String>
        #     * 'zone-id'<~String>
        #   * 'status'<~Integer> - 200 indicates success
        def get_host( host_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Zerigo::DNS::GetHost.new,
            :path     => "/api/1.1/hosts/#{host_id}.xml"
          )
        end

      end
    end
  end
end
