require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Snapshot < Fog::Model

        identity :name

        attribute :kind
        attribute :id
        attribute :self_link         , :aliases => 'selfLink'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :disk_size_gb      , :aliases => 'diskSizeGb'
        attribute :source_disk       , :aliases => 'sourceDisk'
        attribute :source_disk_id    , :aliases => 'sourceDiskId'
        attribute :description
        attribute :status

        

        def reload
          requires :name

          data = service.get_snapshot(name).body

          self.merge_attributes(data)
          self
        end

        def resource_url
          "#{self.service.project}/global/snapshots/#{name}"
        end

        def destroy
          requires :name
          response = service.delete_snapshot(name)
          service.operations.new(response.body)
        end
        alias_method :delete, :destroy

      end

    end
  end
end
