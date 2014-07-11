require 'fog/orchestration/models/outputs'
require 'fog/aws/models/orchestration/output'

module Fog
  module Orchestration
    class AWS
      class Outputs < Fog::Orchestration::Outputs

        model Fog::Orchestration::AWS::Output

        def all(stack)
          load(stack.attributes['Outputs'] || [])
        end

      end
    end
  end
end
