module Fog
  module Network
    class OpenStack

      class Real
        def create_network(options = {})
          data = { 'network' => {} }

          vanilla_options = [
            :name, 
            :shared, 
            :admin_state_up, 
            :tenant_id, 
            :router_external, 
            :provider_network_type,
            :provider_segmentation_id, 
            :provider_physical_network
          ]

          # Advanced Features through API Extensions
          #
          # @see http://docs.openstack.org/trunk/openstack-network/admin/content/provider_attributes.html
          aliases = {
            :provider_network_type     => 'provider:network_type',
            # Not applicable to the "local" or "gre" network types
            :provider_physical_network => 'provider:physical_network',
            :provider_segmentation_id  => 'provider:segmentation_id',
            :router_external           => 'router:external'
          }

          vanilla_options.reject{ |o| options[o].nil? }.each do |key|
            aliased_key = aliases[key] || key
            data['network'][aliased_key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [201],
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
            'id'             => Fog::Mock.random_numbers(6).to_s,
            'name'           => options[:name],
            'shared'         => options[:shared],
            'subnets'        => [],
            'status'         => 'ACTIVE',
            'admin_state_up' => options[:admin_state_up],
            'tenant_id'      => options[:tenant_id],
          }
          self.data[:networks][data['id']] = data
          response.body = { 'network' => data }
          response
        end
      end

    end
  end
end
