module Fog
  module AWS
    class EC2

      def snapshots
        Fog::AWS::EC2::Snapshots.new(:connection => self)
      end

      class Snapshots < Fog::Collection

        def all(snapshot_id = [])
          data = connection.describe_snapshots(snapshot_id)
          snapshots = Fog::AWS::EC2::Snapshots.new(:connection => connection)
          data['snapshotSet'].each do |volume|
            snapshots << Fog::AWS::EC2::Snapshot.new({
              :connection => connection
            }.merge!(snapshot))
          end
          snapshots
        end

        def create(attributes = {})
          volume = new(attributes)
          volume.save
          volume
        end

        def new(attributes = {})
          Fog::AWS::S3::Snapshot.new({
            :connection => connection,
            :volume     => @volume,
            :snapshots  => self
          }.merge!(attributes))
        end

        def volume
          @volume
        end

        private

        def volume=(new_volume)
          @volume = new_volume
        end

      end

    end
  end
end
