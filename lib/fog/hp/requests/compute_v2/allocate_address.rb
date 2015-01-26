module Fog
  module Compute
    class HPV2
      class Real
        # Acquires a floating IP address
        #
        # Note: This method will proxy the call to the Network (Quantum) service,
        # to allocate an floating IP address from the first network available.
        # If the network is not routable, it will throw an exception.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'floating_ip'<~Hash> -
        #     * 'id'<~String> - UUId of the Floating IP address
        #     * 'ip'<~String> - Floating IP of the address
        #     * 'instance_id'<~String> - Id of the associated server instance
        #     * 'fixed_ip'<~String> - Fixed IP of the address
        def allocate_address
          request(
            :body     => nil,
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-floating-ips'
          )
        end
      end

      class Mock
        def allocate_address
          response = Excon::Response.new
          response.status = 200
          data = {
            'instance_id' => Fog::HP::Mock.uuid.to_s,
            'ip'          => Fog::HP::Mock.ip_address,
            'fixed_ip'    => Fog::HP::Mock.ip_address,
            'id'          => Fog::HP::Mock.uuid.to_s
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
