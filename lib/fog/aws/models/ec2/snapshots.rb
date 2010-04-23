require 'fog/collection'
require 'fog/aws/models/ec2/snapshot'

module Fog
  module AWS
    module EC2

      class Mock
        def snapshots(attributes = {})
          Fog::AWS::EC2::Snapshots.new({
            :connection => self
          }.merge!(attributes))
        end
      end

      class Real
        def snapshots(attributes = {})
          Fog::AWS::EC2::Snapshots.new({
            :connection => self
          }.merge!(attributes))
        end
      end

      class Snapshots < Fog::Collection

        attribute :owner,         'Owner'
        attribute :restorable_by, 'RestorableBy'
        attribute :snapshot_id
        attribute :volume

        model Fog::AWS::EC2::Snapshot

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
            all(snapshot_id).first
          end
        rescue Excon::Errors::BadRequest
          nil
        end

        def new(attributes = {})
          if volume
            super({ :volume_id => volume.id }.merge!(attributes))
          else
            super
          end
        end

      end

    end
  end
end
