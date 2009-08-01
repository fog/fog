module Fog
  module AWS
    class EC2

      # Describe all or specified regions
      #
      # ==== Params
      # * region_name<~String> - List of regions to describe, defaults to all
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'regionInfo'<~Array>:
      #       * 'regionName'<~String> - Name of region
      #       * 'regionEndpoint'<~String> - Service endpoint for region
      def describe_regions(region_name = [])
        params = indexed_params('RegionName', region_name)
        request({
          'Action' => 'DescribeRegions'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeRegions.new)
      end

    end
  end
end
