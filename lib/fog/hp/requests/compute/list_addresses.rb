module Fog
  module Compute
    class HP
      class Real
        # List all floating IP addresses
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'floating_ips'<~Array> -
        #       * 'id'<~Integer> - Id of the address
        #       * 'ip'<~String> - Floating IP of the address
        #       * 'instance_id'<~String> - Id of the associated server instance
        #       * 'fixed_ip'<~String> - Fixed IP of the address
        def list_addresses
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "os-floating-ips.json"
          )
        end
      end

      class Mock
        def list_addresses
          response = Excon::Response.new
          addresses = []
          addresses = self.data[:addresses].values unless self.data[:addresses].nil?

          response.status = 200
          response.body = { 'floating_ips' => addresses }
          response
        end
      end
    end
  end
end
