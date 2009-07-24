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
      #     * :request_id<~String> - Id of request
      #     * :region_info<~Array>:
      #       * :region_name<~String> - Name of region
      #       * :region_endpoint<~String> - Service endpoint for region
      def describe_regions(region_name = [])
        params = indexed_params('RegionName', region_name)
        request({
          'Action' => 'DescribeRegions'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeRegions.new)
      end

    end
  end
end
