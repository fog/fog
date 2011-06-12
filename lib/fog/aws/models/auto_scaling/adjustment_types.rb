require 'fog/aws/models/auto_scaling/adjustment_type'
module Fog
  module AWS
    class AutoScaling
      class AdjustmentTypes < Fog::Collection
        model Fog::AWS::AutoScaling::AdjustmentType

        def all
          data = connection.describe_adjustment_types.body['DescribeAdjustmentTypesResult']['AdjustmentTypes']
          load(data)
        end
      end
    end
  end
end
