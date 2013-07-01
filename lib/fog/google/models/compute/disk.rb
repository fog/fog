require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Disk < Fog::Model

        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :id, :aliases => 'id'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :zone, :aliases => 'zone'
        attribute :status, :aliases => 'status'
        attribute :description, :aliases => 'description'
        attribute :size_gb, :aliases => 'sizeGb'
        attribute :self_link, :aliases => 'selfLink'

        def get_as_boot_disk(writable=true)
          mode = writable ? 'READ_WRITE' : 'READ_ONLY'
          return {
              'name' => name,
              'type' => 'PERSISTENT',
              'boot' => true,
              'source' => self_link,
              'mode' => mode
          }
        end

      end
    end
  end
end