require 'fog/orchestration/models/stacks'
require 'fog/rackspace/models/orchestration/stack'

module Fog
  module Orchestration
    class Rackspace
      # Stacks list
      class Stacks < Fog::Orchestration::Stacks

        # Register the stack model class
        model Fog::Orchestration::Rackspace::Stack

        # Load all stacks
        #
        # @return [self]
        def all
          unless(attributes['stacks'])
            attributes['stacks'] = service.list_stacks.body['stacks']
          end
          load(attributes['stacks'])
        end

      end
    end
  end
end
