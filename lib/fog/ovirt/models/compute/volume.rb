module Fog
  module Compute
    class Ovirt

      class Volume < Fog::Model
        attr_accessor :raw
        identity :id

        attribute :storage_domain
        attribute :size
        attribute :disk_type
        attribute :bootable
        attribute :interface
        attribute :format
        attribute :sparse

        def to_s
          id
        end

      end

    end
  end
end
