module Fog
  module Compute
    class BareMetalCloud
      class Real
        # List servers
        #
        # ==== Parameters
        # * serverId<~String> - Id of the server
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Has>:
        #     * server<~Hash>:
        #       * 'id'<~String> - Id of the server
        #       * 'mac-address'<~String>  - mac-address of the server
        #       * 'ip'<~Hash>:
        #         * 'address'<~String>  - Address of the ip
        #         * 'name'<~String>     - Name of the ip
        #       * 'login'<~Hash>:
        #         * 'name'<~String>     - Name of the login
        #         * 'password'<~String> - Password of the login
        #         * 'username'<~String> - Username of the login
        #       * 'name'<~String>   - Name of the server
        #       * 'notes'<~String>  - Notes about the server
        #       * 'state'<~String>  - State of the server
        #
        def get_server(server_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/getServer',
            :query    => {'serverId' => server_id}
          )
        end
      end
    end
  end
end
