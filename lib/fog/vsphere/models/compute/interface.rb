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

        def initialize(attributes={} )
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
