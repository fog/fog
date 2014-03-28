require 'fog/orchestration/models/stacks'
require 'fog/aws/models/orchestration/stack'

module Fog
  module Orchestration
    class AWS
      class Stacks < Fog::Orchestration::Stacks

        model Fog::Orchestration::AWS::Stack

        def all
          load(service.list_stacks.body['StackSummaries'])
        end

        def find_by_name(name)
          self.find{|stack| stack.stack_name == name}
        end

      end
    end
  end
end
