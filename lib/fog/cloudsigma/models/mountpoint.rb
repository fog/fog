require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class MountPoint < Fog::Model
        attribute :device, :type => 'string'
        attribute :dev_channel, :type => 'string'
        attribute :drive
        attribute :boot_order, :type => 'integer'

        def drive
          drive = attributes[:drive]

          drive.kind_of?(Hash) ? drive['uuid'] : drive
        end

        def drive=(new_drive)
          attributes[:drive] = new_drive
        end
        alias_method :volume, :drive
      end
    end
  end
end
