module Fog
  module Compute
    class AWS
      class Real
        require 'fog/aws/parsers/compute/copy_snapshot'

        # Copy a snapshot to a different region
        #
        # ==== Parameters
        # * source_snapshot_id<~String> - Id of snapshot
        # * source_region<~String>      - Region to move it from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - id of request
        #     * 'snapshotId'<~String> - id of snapshot
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-CopySnapshot.html]
        def copy_snapshot(source_snapshot_id, source_region, description = nil)
          request(
            'Action'          => 'CopySnapshot',
            'SourceSnapshotId'=> source_snapshot_id,
            'SourceRegion'    => source_region,
            'Description'     => description,
            :parser       => Fog::Parsers::Compute::AWS::CopySnapshot.new
          )
        end
      end

      class Mock
        #
        # Usage
        #
        # AWS[:compute].copy_snapshot("snap-1db0a957", 'us-east-1')
        #

        def copy_snapshot(source_snapshot_id, source_region, description = nil)
          response = Excon::Response.new
          response.status = 200
          snapshot_id = Fog::AWS::Mock.snapshot_id
          data = {
            'snapshotId'  => snapshot_id,
          }
          self.data[:snapshots][snapshot_id] = data
          response.body = {
            'requestId' => Fog::AWS::Mock.request_id
          }.merge!(data)
          response
        end
      end
    end
  end
end
