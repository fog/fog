require 'fog/orchestration/models/stacks'
require 'fog/aws/models/orchestration/stack'

module Fog
  module Orchestration
    class AWS
      class Stacks < Fog::Orchestration::Stacks

        model Fog::Orchestration::AWS::Stack

        def all
          list = service.list_stacks.body['StackSummaries']
          describe = service.describe_stacks.body['Stacks']
          stack_defs = list.map do |stack_hash|
            desc_hash = describe.detect{|h| h['StackId'] == stack_hash['StackId']}
            stack_hash.merge!(desc_hash) if desc_hash
            stack_hash
          end
          load(stack_defs)
        end

        def find_by_name(name)
          self.find{|stack| stack.stack_name == name}
        end

      end
    end
  end
end
