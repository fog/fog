module Fog
  module AWS
    class EC2

      def snapshots(attributes = {})
        Fog::AWS::EC2::Snapshots.new({
          :connection => self
        }.merge!(attributes))
      end

      class Snapshots < Fog::Collection

        attribute :snapshot_id
        attribute :volume

        model Fog::AWS::EC2::Snapshot

        def initialize(attributes)
          @snapshot_id ||= []
          super
        end

        def all(snapshot_id = @snapshot_id)
          @snapshot_id = snapshot_id
          if @loaded
            clear
          end
          @loaded = true
          data = connection.describe_snapshots(snapshot_id).body
          snapshots = []
          data['snapshotSet'].each do |snapshot|
            snapshots << new(snapshot)
          end
          if volume
            snapshots = snapshots.select {|snapshot| snapshot.volume_id == volume.id}
          end
          self.replace(snapshots)
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
