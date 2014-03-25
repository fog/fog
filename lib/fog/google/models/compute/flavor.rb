require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Flavor < Fog::Model

        identity :name

        attribute :description
        attribute :guest_cpus, :aliases => 'guestCpus'
        attribute :memory_mb, :aliases => 'memoryMb'
        attribute :image_space_gb, :aliases => 'imageSpaceGb'
        attribute :maximum_persistent_disks,
          :aliases => 'maximumPersistentDisks'
        attribute :maximum_persistent_disks_size,
          :aliases => 'maximumPersistentDisksSizeGb'
        attribute :self_link, :aliases => 'selfLink'

      end

    end
  end
end
