module Fog
  module Compute
    class Ecloudv2
      class Network < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :address, :aliases => :Address
        attribute :network_type, :aliases => :NetworkType
        attribute :broadcast_address, :aliases => :BroadcastAddress
        attribute :gateway_address, :aliases => :GatewayAddress
        attribute :rnat_address, :aliases => :RnatAddress

        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
