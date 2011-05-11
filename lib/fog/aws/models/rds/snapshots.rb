require 'fog/core/collection'
require 'fog/aws/models/rds/snapshot'

module Fog
  module AWS
    class RDS

      class Snapshots < Fog::Collection
        attribute :server
        attribute :filters
        model Fog::AWS::RDS::Snapshot

        def initialize(attributes)
          self.filters ||= {}
          if attributes[:server]
            filters[:identifier] = attributes[:server].id
          end
          super
        end

        def all(filters = filters)
          self.filters = filters
          data = connection.describe_db_snapshots(filters).body['DescribeDBSnapshotsResult']['DBSnapshots']
          load(data) # data is an array of attribute hashes
        end

        def get(identity)
          data = connection.describe_db_snapshots(:snapshot_id => identity).body['DescribeDBSnapshotsResult']['DBSnapshots'].first
          new(data) # data is an attribute hash
        rescue Fog::AWS::RDS::NotFound
          nil
        end

        def new(attributes = {})
          if server
            super({ :instance_id => server.id }.merge!(attributes))
          else
            super
          end
        end

      end
    end
  end
end