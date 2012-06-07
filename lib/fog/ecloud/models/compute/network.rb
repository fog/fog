module Fog
  module Compute
    class Ecloud
      class Network < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :address, :aliases => :Address
        attribute :network_type, :aliases => :NetworkType
        attribute :broadcast_address, :aliases => :BroadcastAddress
        attribute :gateway_address, :aliases => :GatewayAddress
        attribute :rnat_address, :aliases => :RnatAddress

        def rnats
          @rnats ||= Fog::Compute::Ecloud::Rnats.new(:connection => connection, :href => "cloudapi/ecloud/rnats/networks/#{id}")
        end

        def ips
          @ips ||= Fog::Compute::Ecloud::IpAddresses.new(:connection => connection, :href => href)
        end

        def edit_rnat_association(options)
          options[:uri] = href
          data = connection.rnat_associations_edit_network(options).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end
        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
