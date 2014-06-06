module Fog
  module HP
    class Network
      class Real
        # Update attributes for an existing network
        #
        # ==== Parameters
        # * 'network_id'<~String>: - UUId of the network
        # * options<~Hash>:
        #   * 'name'<~String> - Name of the network
        #   * 'admin_state_up'<~Boolean> - The administrative state of the network, true or false
        #   * 'shared'<~Boolean> - true or false
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * network<~Hash>:
        #       * 'id'<~String>: - UUId for the network
        #       * 'name'<~String>: - Name of the network
        #       * 'tenant_id'<~String>: - TenantId that owns the network
        #       * 'status'<~String>: - Status of the network i.e. "ACTIVE"
        #       * 'subnets'<~Array>: - Subnets for the network
        #         * 'id'<~Integer>: - UUId for the subnet
        #       * 'admin_state_up'<~Boolean>: - true or false
        #       * 'shared'<~Boolean>: - true or false
        def update_network(network_id, options = {})
          data = { 'network' => {} }

          l_options = [:name, :admin_state_up, :shared]
          l_options.select{|o| options[o]}.each do |key|
            data['network'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "networks/#{network_id}"
          )
        end
      end

      class Mock
        def update_network(network_id, options = {})
          response = Excon::Response.new
          if network = list_networks.body['networks'].find {|_| _['id'] == network_id}
            network['name']           = options[:name]
            network['shared']         = options[:shared]
            network['admin_state_up'] = options[:admin_state_up]
            response.body = { 'network' => network }
            response.status = 200
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
