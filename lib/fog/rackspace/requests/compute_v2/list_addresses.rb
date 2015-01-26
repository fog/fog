module Fog
  module Compute
    class RackspaceV2
      class Real
        # Lists all networks and addresses associated with a specified server.
        # @param [String] server_id
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * addresses [Hash] - key is the network name and the value are an array of addresses allocated for that network
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def list_addresses(server_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/servers/#{server_id}/ips"
          )
        end
      end

      class Mock
        def list_addresses(server_id)
          raise Fog::Compute::RackspaceV2::NotFound.new if server_id == 0
          response        = Excon::Response.new
          response.status = 200
          response.body   = {
            "addresses" => {
              "public"=>[{"version"=>6, "addr"=>"2001:4800:7811:0513:0fe1:75e8:ff04:760b"}, {"version"=>4, "addr"=>"166.78.18.176"}],
              "private"=>[{"version"=>4, "addr"=>"10.181.129.68"}]
            }
          }
          response
        end
      end
    end
  end
end
