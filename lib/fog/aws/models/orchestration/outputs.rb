require 'fog/orchestration/models/outputs'
require 'fog/aws/models/orchestration/output'

module Fog
  module Orchestration
    class AWS
      class Outputs < Fog::Orchestration::Outputs

        model Fog::Orchestration::AWS::Output

        def all(stack)
          stack.expand! unless stack.data
          load(
            stack.data['Outputs'].map do |_output|
              Hash[
                _output.map do |k,v|
                  [k.sub('output_', ''), v]
                end
              ]
            end
          )
        end

      end
    end
  end
end
