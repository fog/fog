module Fog
  module Compute
    class Vsphere

      class Interface < Fog::Model

        identity :mac
        alias :id :mac

        attribute :network
        attribute :name
        attribute :status
        attribute :summary
        attribute :type
        attribute :key
        attribute :virtualswitch

        def initialize(attributes={} )
          if attributes.has_key? :type and attributes[:type].is_a? String then
             attributes[:type]=Fog.class_from_string(attributes[:type], "RbVmomi::VIM")
          end
          super defaults.merge(attributes)
        end

        def to_s
          name
        end

        private

        def defaults
          default_type=Fog.credentials[:default_nic_type] || RbVmomi::VIM::VirtualE1000
          {
            :name=>"Network adapter",
            :network=>"VM Network",
            :summary=>"VM Network",
            :type=> Fog.class_from_string(default_type, "RbVmomi::VIM"),
          }
        end

      end

    end
  end
end
