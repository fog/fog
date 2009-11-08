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
        attribute :volume_id

        model Fog::AWS::EC2::Snapshot

        def initialize(attributes)
          @snapshot_id ||= []
          super
        end

        def all(snapshot_id = @snapshot_id)
          data = connection.describe_snapshots(snapshot_id).body
          snapshots = Fog::AWS::EC2::Snapshots.new({
            :connection   => connection,
            :snapshot_id  => snapshot_id
          }.merge!(attributes))
          data['snapshotSet'].each do |snapshot|
            snapshots << Fog::AWS::EC2::Snapshot.new({
              :collection => snapshots,
              :connection => connection
            }.merge!(snapshot))
          end
          if volume_id
            snapshots = snapshots.select {|snapshot| snapshot.volume_id == volume_id}
          end
          snapshots
        end

        def get(snapshot_id)
          if snapshot_id
            all(snapshot_id).first
          end
        rescue Excon::Errors::BadRequest
          nil
        end

        def new(attributes = {})
          snapshot = super(attributes)
          if volume_id
            snapshot.volume_id = volume_id
          end
          snapshot
        end

      end

    end
  end
end
