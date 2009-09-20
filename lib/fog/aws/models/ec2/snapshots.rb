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
          data['snapshotSet'].each do |snapshot|
            snapshots << Fog::AWS::EC2::Snapshot.new({
              :connection => connection,
              :snapshots  => self
            }.merge!(snapshot))
          end
          snapshots
        end

        def create(attributes = {})
          snapshot = new(attributes)
          snapshot.save
          snapshot
        end

        def new(attributes = {})
          Fog::AWS::EC2::Snapshot.new(
            attributes.merge!(
              :connection => connection,
              :volume     => @volume,
              :snapshots  => self
            )
          )
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
