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

          snapshots = service.describe_db_snapshots(filters)
          self.filters[:marker] = snapshots.body['DescribeDBSnapshotsResult']['Marker']
          data = snapshots.body['DescribeDBSnapshotsResult']['DBSnapshots']
          load(data)
        end

        # This will execute a block for each snapshot, fetching new pages of snapshots as required.
        def each(filters = filters)
          begin
            page = self.all(filters)
            # We need to explicitly use the base 'each' method here on the page, otherwise we get infinite recursion
            base_each = Fog::Collection.instance_method(:each)
            base_each.bind(page).call {|snapshot| yield snapshot}
          end while self.filters[:marker]
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
