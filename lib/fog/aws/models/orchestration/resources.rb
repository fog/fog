require 'fog/orchestration/models/resources'
require 'fog/aws/models/orchestration/resource'
require 'fog/aws/models/orchestration/common'

module Fog
  module Orchestration
    class AWS
      # Resources for stack
      class Resources < Fog::Orchestration::Resources

        include Fog::Orchestration::AWS::Common

        # Register stack resource model
        model Fog::Orchestration::AWS::Resource

        # Load all resources for stack
        #
        # @param load_stack [Fog::Orchestration::AWS::Stack]
        # @return [self]
        def all(load_stack=nil)
          self.stack = load_stack if load_stack
          if(self.stack)
            unless(self.stack.attributes['Resources'])
              self.stack.attributes['Resources'] = fetch_paged_results('StackResourceSummaries') do |opts|
                service.list_stack_resources(opts.merge('StackName' => self.stack.stack_name))
              end
            end
            items = self.stack.attributes['Resources']
          else
            items = []
          end
          load(items)
        end

      end

    end
  end
end
