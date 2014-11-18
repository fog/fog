module Fog
  module AWS
    module RegionMethods
      def validate_aws_region host, region
        if host.end_with?('.amazonaws.com') && !['ap-northeast-1', 'ap-southeast-1', 'ap-southeast-2', 'eu-west-1', 'us-east-1', 'us-west-1', 'us-west-2', 'sa-east-1', 'us-gov-west-1', 'eu-central-1'].include?(region)
          raise ArgumentError, "Unknown region: #{region.inspect}"
        end
      end
    end
  end
end
