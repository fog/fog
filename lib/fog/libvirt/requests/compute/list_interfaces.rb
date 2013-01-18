module Fog
  module Compute
    class Libvirt
      class Real
        def list_interfaces(filter = { })
          data=[]
          if filter.keys.empty?
            active_networks = client.list_interfaces rescue []
            defined_networks = client.list_defined_interfaces rescue []
            (active_networks + defined_networks).each do |ifname|
              data << interface_to_attributes(client.lookup_interface_by_name(ifname))
            end
          else
            data = [interface_to_attributes(get_interface_by_filter(filter))]
          end
          data.compact
        end

        private
        # Retrieve the interface by mac or by name
        def get_interface_by_filter(filter)
          case filter.keys.first
            when :mac
              client.lookup_interface_by_mac(filter[:mac])
            when :name
              client.lookup_interface_by_name(filter[:name])
          end

        end

        def interface_to_attributes(net)
          return if net.nil? || net.name == 'lo'
          {
            :mac    => net.mac,
            :name   => net.name,
            :active => net.active?
          }
        end

      end

      class Mock
        def list_interfaces(filters={ })
          if1 = mock_interface 'if1'
          if2 = mock_interface 'if2'
          [if1, if2]
        end

        def mock_interface name
          {
              :mac    => 'aa:bb:cc:dd:ee:ff',
              :name   => name,
              :active => true
          }
        end
      end
    end
  end
end
