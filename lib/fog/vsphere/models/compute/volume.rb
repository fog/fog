module Fog
  module Compute
    class Vsphere

      class Volume < Fog::Model
        DISK_SIZE_TO_GB = 1048576
        identity :id

        attribute :datastore
        attribute :mode
        attribute :size
        attribute :thin
        attribute :name
        attribute :filename
        attribute :size_gb

        def initialize(attributes={} )
          super defaults.merge(attributes)
        end

        def size_gb
          attributes[:size_gb] ||= attributes[:size].to_i / DISK_SIZE_TO_GB if attributes[:size]
        end

        def size_gb= s
          attributes[:size] = s.to_i * DISK_SIZE_TO_GB if s
        end

        def to_s
          name
        end

         private

        def defaults
          {
            :thin=>true,
            :name=>"Hard disk",
            :mode=>"persistent"
          }
        end
      end
    end
  end
end
