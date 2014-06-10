module Fog
  module Compute
    class HP
      class Real
        # Acquires a floating IP address
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'floating_ip'<~Hash> -
        #       * 'id'<~Integer> - Id of the address
        #       * 'ip'<~String> - Floating IP of the address
        #       * 'instance_id'<~String> - Id of the associated server instance
        #       * 'fixed_ip'<~String> - Fixed IP of the address
        def allocate_address
          request(
            :body     => nil,
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-floating-ips.json'
          )
        end
      end

      class Mock
        def allocate_address
          response = Excon::Response.new
          response.status = 200
          data = {
            'instance_id' => Fog::HP::Mock.instance_id.to_i,
            'ip'          => Fog::HP::Mock.ip_address,
            'fixed_ip'    => Fog::HP::Mock.ip_address,
            'id'          => Fog::Mock.random_numbers(3).to_i
          }
          self.data[:last_modified][:addresses][data['id']] = Time.now
          self.data[:addresses][data['id']] = data

          response.body = { 'floating_ip' => data }
          response
        end
      end
    end
  end
end
