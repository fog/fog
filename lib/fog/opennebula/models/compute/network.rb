require 'fog/core/model'

module Fog
  module Compute
    class OpenNebula
      class Network < Fog::Model

        identity :id
        attribute :name
        attribute :uname
        attribute :uid
        attribute :gid
        attribute :description
        attribute :vlan

        def description
          attributes[:description] || ""
        end

        def vlan
          attributes[:vlan] || ""
        end

        def save
          raise Fog::Errors::Error.new('Creating a new network is not yet implemented. Contributions welcome!')
        end

        def shutdown
          raise Fog::Errors::Error.new('Shutting down a new network is not yet implemented. Contributions welcome!')
        end

        def to_label
          ret = ""
          ret += "#{description} - " unless description.empty?
          ret += "VLAN #{vlan} - " unless vlan.empty?
          ret += "#{name}"
        end

      end
    end
  end
end
