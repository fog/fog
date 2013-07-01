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
          if attributes[:type]
            filters[:type] = attributes[:type]
          end
          super
        end

        # This will return a single page based on the current or provided filters,
        # updating the filters with the marker for the next page.  Calling this repeatedly
        # will iterate through pages.
        def all(filters = filters)
          self.filters.merge!(filters)

          data = []
          begin
            result = service.describe_db_snapshots(filters).body['DescribeDBSnapshotsResult']
            self.filters[:marker] = result['Marker']
            data.concat(result['DBSnapshots'])
          end while self.filters[:marker]
          load(data)
        end

        def get(identity)
          data = service.describe_db_snapshots(:snapshot_id => identity).body['DescribeDBSnapshotsResult']['DBSnapshots'].first
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
