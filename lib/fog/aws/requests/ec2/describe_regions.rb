unless Fog.mocking?

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

else

  module Fog
    module AWS
      class EC2

        def describe_regions(region_name = [])
          response = Fog::Response.new
          region_name = [*region_name]
          regions = {
            'eu-west-1' => {"regionName"=>"eu-west-1", "regionEndpoint"=>"eu-west-1.ec2.amazonaws.com"},
            'us-east-1' => {"regionName"=>"us-east-1", "regionEndpoint"=>"us-east-1.ec2.amazonaws.com"}
          }
          if region_name != []
            region_info = regions.reject {|key, value| !region_name.include?(key)}.values
          else
            region_info = regions.values
          end

          response.status = 200
          response.body = {
            'requestId'   => Fog::AWS::Mock.request_id,
            'regionInfo'  => region_info
          }
          response
        end

      end
    end
  end

end
