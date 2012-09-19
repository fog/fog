module Fog
  module Compute
    class BareMetalCloud
      class Real

        # List servers
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * no parameters are required
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * server<~Array>:
        #       * 'id'<~String>     - Id of the server
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
        def list_servers(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/listServers',
            :query    => options
          )
        end

      end
    end
  end
end
