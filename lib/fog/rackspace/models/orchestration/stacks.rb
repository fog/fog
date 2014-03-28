require 'fog/orchestration/models/stacks'
require 'fog/rackspace/models/orchestration/stack'

module Fog
  module Orchestration
    class Rackspace
      class Stacks < Fog::Orchestration::Stacks

        model Fog::Orchestration::Rackspace::Stack

        def all
          load(service.list_stacks.body['stacks'])
        end

        def find_by_name(name)
          self.find{|stack| stack.stack_name == name}
        end

      end
    end
  end
end
