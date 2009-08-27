unless Fog.mocking?

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

else

  module Fog
    module AWS
      class EC2

        def describe_availability_zones(zone_name = [])
          response = Fog::Response.new
          zone_name = [*zone_name]
          zones = {
            'us-east-1a' => {"zoneName"=>"us-east-1a", "regionName"=>"us-east-1", "zoneState"=>"available"}, 
            'us-east-1b' => {"zoneName"=>"us-east-1b", "regionName"=>"us-east-1", "zoneState"=>"available"}, 
            'us-east-1c' => {"zoneName"=>"us-east-1c", "regionName"=>"us-east-1", "zoneState"=>"available"}, 
            'us-east-1d' => {"zoneName"=>"us-east-1d", "regionName"=>"us-east-1", "zoneState"=>"available"}
          }
          if zone_name != []
            availability_zone_info = zones.reject {|key, value| !zone_name.include?(key)}.values
          else
            availability_zone_info = zones.values
          end

          response.status = 200
          response.body = {
            'requestId'             => Fog::AWS::Mock.request_id,
            'availabilityZoneInfo'  => availability_zone_info
          }
          response
        end

      end
    end
  end

end
