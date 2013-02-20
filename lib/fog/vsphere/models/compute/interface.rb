module Fog
  module Compute
    class Vsphere

      class Interface < Fog::Model

        identity :mac

        attribute :network
        attribute :name
        attribute :status
        attribute :summary
        attribute :type

        def initialize(attributes={} )
          default_type=Fog.credentials[:default_nic_type]
          if attributes.has_key? :type and attributes[:type].is_a? String then
             attributes[:type]=Fog.class_from_string(attributes[:type])
          elsif default_type then
             attributes[:type]=Fog.class_from_string(default_type)
          end
          super defaults.merge(attributes)
        end

        def to_s
          name
        end

        private

        def defaults
          {
            :name=>"Network adapter",
            :network=>"VM Network",
            :summary=>"VM Network",
            :type=> RbVmomi::VIM::VirtualE1000,
          }
        end

      end

    end
  end
end
