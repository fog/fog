module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/describe_route_tables'

        # Describe all or specified volumes.
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'volumeSet'<~Array>:
        #       * 'availabilityZone'<~String> - Availability zone for volume
        #       * 'createTime'<~Time> - Timestamp for creation
        #       * 'size'<~Integer> - Size in GiBs for volume
        #       * 'snapshotId'<~String> - Snapshot volume was created from, if any
        #       * 'status'<~String> - State of volume
        #       * 'volumeId'<~String> - Reference to volume
        #       * 'attachmentSet'<~Array>:
        #         * 'attachmentTime'<~Time> - Timestamp for attachment
        #         * 'deleteOnTermination'<~Boolean> - Whether or not to delete volume on instance termination
        #         * 'device'<~String> - How value is exposed to instance
        #         * 'instanceId'<~String> - Reference to attached instance
        #         * 'status'<~String> - Attachment state
        #         * 'volumeId'<~String> - Reference to volume
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeVolumes.html]
        def describe_route_tables(filters = {})
          unless filters.is_a?(Hash)
            Fog::Logger.deprecation("describe_route_tables with #{filters.class} param is deprecated, use describe_route_tables('route-table-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'route-table-id' => [*filters]}
          end
          params = Fog::AWS.indexed_filters(filters)
          request({
            'Action'    => 'DescribeRouteTables',
            :parser     => Fog::Parsers::Compute::AWS::DescribeRouteTables.new
          }.merge!(params))
        end

      end

      class Mock


      end
    end
  end
end
