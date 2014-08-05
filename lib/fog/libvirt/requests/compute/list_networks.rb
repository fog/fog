module Fog
  module Compute
    class Libvirt
      class Real
        def list_networks(filter = { })
          data=[]
          if filter.keys.empty?
            (client.list_networks + client.list_defined_networks).each do |network_name|
              data << network_to_attributes(client.lookup_network_by_name(network_name))
            end
          else
            data = [network_to_attributes(get_network_by_filter(filter))]
          end
          data
        end

        private
        # Retrieve the network by uuid or name
        def get_network_by_filter(filter)
          case filter.keys.first
            when :uuid
              client.lookup_network_by_uuid(filter[:uuid])
            when :name
              client.lookup_network_by_name(filter[:name])
          end
        end

        def network_to_attributes(net)
          return if net.nil?
          {
            :uuid        => net.uuid,
            :name        => net.name,
            :bridge_name => net.bridge_name
          }
        end
      end

      class Mock
        def list_networks(filters={ })
          net1 = mock_network 'net1'
          net2 = mock_network 'net2'
          [net1, net2]
        end

        def mock_network name
          {
              :uuid        => 'net.uuid',
              :name        => name,
              :bridge_name => 'net.bridge_name'
          }
        end
      end
    end
  end
end
