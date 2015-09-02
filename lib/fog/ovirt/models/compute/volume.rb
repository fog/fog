module Fog
  module Compute
    class Ovirt
      class Volume < Fog::Model
        attr_accessor :raw
        DISK_SIZE_TO_GB = 1073741824
        identity :id

        attribute :storage_domain
        attribute :size
        attribute :disk_type
        attribute :bootable
        attribute :interface
        attribute :format
        attribute :sparse
        attribute :size_gb
        attribute :status
        attribute :quota
        attribute :alias
        attribute :wipe_after_delete

        def size_gb
          attributes[:size_gb] ||= attributes[:size].to_i / DISK_SIZE_TO_GB if attributes[:size]
        end

        def size_gb= s
          attributes[:size] = s.to_i * DISK_SIZE_TO_GB if s
        end

        def to_s
          id
        end
      end
    end
  end
end
