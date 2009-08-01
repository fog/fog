module Fog
  module AWS
    class EC2

      # Describe all or specified availability zones
      #
      # ==== Params
      # * zone_name<~String> - List of availability zones to describe, defaults to all
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'availabilityZoneInfo'<~Array>:
      #       * 'regionName'<~String> - Name of region
      #       * 'zoneName'<~String> - Name of zone
      #       * 'zoneState'<~String> - State of zone
      def describe_availability_zones(zone_name = [])
        params = indexed_params('ZoneName', zone_name)
        request({
          'Action' => 'DescribeAvailabilityZones'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeAvailabilityZones.new)
      end

    end
  end
end
