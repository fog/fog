require 'fog/core/collection'
require 'fog/aws/models/compute/snapshot'

module Fog
  module AWS
    class Compute

      class Snapshots < Fog::Collection

        attribute :owner,         :aliases => 'Owner'
        attribute :restorable_by, :aliases => 'RestorableBy'
        attribute :snapshot_id
        attribute :volume

        model Fog::AWS::Compute::Snapshot

        def initialize(attributes)
          @snapshot_id ||= []
          super
        end

        def all(snapshot_id = @snapshot_id, options = {})
          options = {
            'Owner' => @owner || 'self',
            'RestorableBy' => @restorable_by
          }
          options = options.reject {|key,value| value.nil? || value.to_s.empty?}
          merge_attributes(options)
          data = connection.describe_snapshots(snapshot_id).body
          load(data['snapshotSet'])
          if volume
            self.replace(self.select {|snapshot| snapshot.volume_id == volume.id})
          end
          self
        end

        def get(snapshot_id)
          if snapshot_id
            self.class.new(:connection => connection).all(snapshot_id).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def new(attributes = {})
          if volume
            super({ 'volumeId' => volume.id }.merge!(attributes))
          else
            super
          end
        end

      end

    end
  end
end
