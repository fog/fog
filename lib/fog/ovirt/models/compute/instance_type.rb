module Fog
  module Compute
    class Ovirt
      class InstanceType < Fog::Model
        identity :id

        attr_accessor :raw

        attribute :name
        attribute :description
        attribute :memory
        attribute :cores
        attribute :creation_time
        attribute :os
        attribute :ha
        attribute :ha_priority
        attribute :display
        attribute :usb
        attribute :migration_downtime
        attribute :type
        attribute :status
        attribute :cpu_shares
        attribute :boot_menu
        attribute :origin
        attribute :stateless
        attribute :delete_protected
        attribute :sso
        attribute :timezone
        attribute :migration
        attribute :io_threads
        attribute :memory_garanteed

        def to_s
          name
        end
      end
    end
  end
end
