module Fog
  module Compute
    class RackspaceV2
      class Real
        # Lists all addresses associated with a specified server and network
        # @param [String] server_id
        # @param [String] network_id
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * network [Hash]:
        #       * id [String] - id of network
        #       * ip [Array]:
        #         * [Hash]:
        #           * version [Fixnum] - version of the address
        #           * addr [String] - ip address
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Addresses_by_Network-d1e3118.html
        def list_addresses_by_network(server_id, network_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "servers/#{server_id}/ips/#{network_id}"
          )
        end
      end

      class Mock
        RESPONSE_BODY = {
          "addresses" => {
            "public"=>[{"version"=>6, "addr"=>"2001:4800:7811:0513:0fe1:75e8:ff04:760b"}, {"version"=>4, "addr"=>"166.78.18.176"}],
            "private"=>[{"version"=>4, "addr"=>"10.181.129.68"}]
          }
        }

        def list_addresses_by_network(server_id, network_id)
          raise Fog::Compute::RackspaceV2::NotFound.new if server_id == 0
          response        = Excon::Response.new
          response.status = 200
          response.body   = { network_id => RESPONSE_BODY["addresses"][network_id] }
          response
        end
      end
    end
  end
end
