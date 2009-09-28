module Fog
  module AWS
    class EC2

      def snapshots
        Fog::AWS::EC2::Snapshots.new(:connection => self)
      end

      class Snapshots < Fog::Collection

        attribute :snapshot_id
        attribute :volume_id

        def initialize(attributes)
          @snapshot_id ||= []
          super
        end

        def all(snapshot_id = [])
          data = connection.describe_snapshots(snapshot_id).body
          snapshots = Fog::AWS::EC2::Snapshots.new({
            :connection   => connection,
            :snapshot_id  => snapshot_id
          }.merge!(attributes))
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

        def get(snapshot_id)
          all(snapshot_id).first
        rescue Fog::Errors::BadRequest
          nil
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

        def reload
          all(snapshot_id)
        end

      end

    end
  end
end
