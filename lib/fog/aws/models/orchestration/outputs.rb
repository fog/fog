require 'fog/orchestration/models/outputs'
require 'fog/aws/models/orchestration/output'

module Fog
  module Orchestration
    class AWS
      # Outputs for stack
      class Outputs < Fog::Orchestration::Outputs

        # Register stack output model
        model Fog::Orchestration::AWS::Output

        # Load all outputs for stack
        #
        # @param load_stack [Fog::Orchestration::AWS::Stack]
        # @return [self]
        def all(load_stack=nil)
          self.stack = load_stack if load_stack
          if(self.stack)
            items = self.stack.attributes['Outputs']
          else
            items = []
          end
          load(items)
        end

        # Reload stack to refresh outputs
        #
        # @return [self]
        def reload
          if(self.stack)
            self.stack.reload
          end
          super
        end

      end
    end
  end
end
