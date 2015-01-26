module Fog
  module HP
    class Network
      class Real
        # Create a new server
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'name'<~String> - Name of the network
        #   * 'admin_state_up'<~Boolean> - The administrative state of the network, true or false
        #   * 'shared'<~Boolean> - true or false
        #   * 'tenant_id'<~String> - TenantId different than the current user, that should own the network. Only allowed if user has 'admin' role.
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
        #       * 'router:external'<~Boolean>: - true or false
        #       * 'admin_state_up'<~Boolean>: - true or false
        #       * 'shared'<~Boolean>: - true or false
        def create_network(options = {})
          data = { 'network' => {} }

          l_options = [:name, :admin_state_up, :shared, :tenant_id]
          l_options.select{|o| options[o]}.each do |key|
            data['network'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 201,
            :method   => 'POST',
            :path     => 'networks'
          )
        end
      end

      class Mock
        def create_network(options = {})
          response = Excon::Response.new
          response.status = 201
          data = {
            'id'              => Fog::HP::Mock.uuid.to_s,
            'name'            => options[:name] || "",
            'tenant_id'       => options[:tenant_id] || Fog::Mock.random_numbers(14).to_s,
            'status'          => 'ACTIVE',
            'subnets'         => [],
            'router:external' => false,
            'admin_state_up'  => options[:admin_state_up] || true,
            'shared'          => options[:shared] || false
          }
          self.data[:networks][data['id']] = data
          response.body = { 'network' => data }
          response
        end
      end
    end
  end
end
