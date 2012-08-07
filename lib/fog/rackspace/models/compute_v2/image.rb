require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class Image < Fog::Model
        UNKNOWN = 'UNKNOWN'
        ACTIVE = 'ACTIVE'
        SAVING = 'SAVING'
        ERROR = 'ERROR'
        DELETED = 'DELETED'

        identity :id

        attribute :name
        attribute :created
        attribute :updated
        attribute :state, :aliases => 'status'
        attribute :user_id
        attribute :tenant_id
        attribute :progress
        attribute :minDisk
        attribute :minRam
        attribute :metadata
        attribute :disk_config, :aliases => 'OS-DCF:diskConfig'
        attribute :links
      end
    end
  end
end
