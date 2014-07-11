require 'fog/core/model'

module Fog
  module Compute
    class Google
      class DiskType < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :deprecated
        attribute :description
        attribute :self_link, :aliases => 'selfLink'
        attribute :valid_disk_size, :aliases => 'validDiskSize'
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
