require 'fog/aws/models/auto_scaling/process_type'
module Fog
  module AWS
    class AutoScaling
      class ProcessTypes < Fog::Collection
        model Fog::AWS::AutoScaling::ProcessType

        def all
          data = connection.describe_scaling_process_types.body['DescribeScalingProcessTypesResult']['Processes']
          load(data)
        end
      end
    end
  end
end
