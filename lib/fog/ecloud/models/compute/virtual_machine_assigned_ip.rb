module Fog
  module Compute
    class Ecloud
      class VirtualMachineAssignedIp < Fog::Ecloud::Model
        identity :href

        attribute :network, :aliases => :Networks
        attribute :address

        def id
          href.scan(/\d+/)[0]
        end

        def network=(network)
          network = network.dup
          network_address = network[:Network]
          @network = self.service.networks.new(network_address)
          network_id = @network.href.match(/(\d+)$/)[1]
          address_ip = network_address[:IpAddresses][:IpAddress]
          @address = self.service.ip_addresses.new(
            :href => "#{service.base_path}/ipaddresses/networks/#{network_id}/#{address_ip}",
            :name => address_ip
          )
        end
        attr_reader :network

        def address=(address); end
        attr_reader :address
      end
    end
  end
end
