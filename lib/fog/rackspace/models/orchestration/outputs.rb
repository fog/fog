require 'fog/orchestration/models/outputs'
require 'fog/rackspace/models/orchestration/output'

module Fog
  module Orchestration
    class Rackspace
      # Outputs for stack
      class Outputs < Fog::Orchestration::Outputs

        # Register stack output model
        model Fog::Orchestration::Rackspace::Output

        # Load all outputs for stack
        #
        # @param load_stack [Fog::Orchestration::Rackspace::Stack]
        # @return [self]
        def all(load_stack=nil)
          self.stack = load_stack if load_stack
          if(self.stack)
            self.stack.expand!
            items = stack.attributes['outputs']
          else
            items = []
          end
          load(
            items.map do |_output|
              Hash[
                _output.map do |k,v|
                  [k.sub('output_', ''), v]
                end
              ]
            end
          )
        end

        # Remove cached outputs data
        #
        # @return [self]
        def reload
          if(self.stack)
            self.stack.attributes.delete('outputs')
            self.stack.reload
          end
          super
        end

      end
    end
  end
end
