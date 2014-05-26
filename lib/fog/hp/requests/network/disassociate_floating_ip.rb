module Fog
  module HP
    class Network
      class Real
        # Associate port with floating ip
        #
        # ==== Parameters
        #   * 'floating_ip_id'<~String>: - UUId of the floating IP address to associate with
        # * options<~Hash>:
        #   * 'fixed_ip_address'<~String>: - Fixed IP address associated to the floating IP, nil to disassociate
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * floatingip<~Array>:
        #       * 'id'<~String>: - UUId for the floating ip
        #       * 'tenant_id'<~String>: - TenantId that owns the floating ip
        #       * 'floating_network_id'<~String>: - UUId of the external network
        #       * 'router_id'<~String>: - Id of the router, null if not assigned
        #       * 'fixed_ip_address'<~String>: - Fixed IP address associated to the floating IP, null if not assigned
        #       * 'floating_ip_address'<~String>: - Floating IP address
        #       * 'port_id'<~String>: - Port associated to the floating IP, null if not assigned
        def disassociate_floating_ip(floating_ip_id, options = {})
          data = {
            'floatingip' => {
              'port_id' => nil              # nil, to disassociate
            }
          }

          l_options = [:fixed_ip_address]
          l_options.select{|o| options[o]}.each do |key|
            data['floatingip'][key] = nil   # nil, to disassociate
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "floatingips/#{floating_ip_id}"
          )
        end
      end

      class Mock
        def disassociate_floating_ip(floating_ip_id, options = {})
          response = Excon::Response.new
          if list_floating_ips.body['floatingips'].find {|_| _['id'] == floating_ip_id}
            response.status = 200
            data = {
                'id'                  => floating_ip_id,
                'port_id'             => nil,
                'router_id'           => Fog::HP::Mock.uuid.to_s,
                'tenant_id'           => Fog::Mock.random_numbers(14).to_s,
                'floating_network_id' => Fog::HP::Mock.uuid.to_s,
                'fixed_ip_address'    => nil,
                'floating_ip_address' => Fog::HP::Mock.ip_address.to_s
            }

            self.data[:floating_ips][data['id']] = data
            response.body = { 'floatingip' => data }
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
