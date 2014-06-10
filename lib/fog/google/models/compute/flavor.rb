require 'fog/core/model'

module Fog
  module Compute
    class Google
      class Flavor < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :deprecated
        attribute :description
        attribute :guest_cpus, :aliases => 'guestCpus'
        attribute :image_space_gb, :aliases => 'imageSpaceGb'
        attribute :maximum_persistent_disks, :aliases => 'maximumPersistentDisks'
        attribute :maximum_persistent_disks_size, :aliases => 'maximumPersistentDisksSizeGb'
        attribute :memory_mb, :aliases => 'memoryMb'
        attribute :scratch_disks, aliases => 'scratchDisks'
        attribute :self_link, :aliases => 'selfLink'
        attribute :zone

        def reload
          requires :identity, :zone

          data = collection.get(identity, self.zone)
          merge_attributes(data.attributes)
          self
        end
      end
    end
  end
end
