require 'fog/core/collection'
require 'fog/cloudatcost/models/task'

module Fog
  module Compute
    class CloudAtCost
      class Tasks < Fog::Collection
        model Fog::Compute::CloudAtCost::Task

        # Returns list of tasks
        # @return [Fog::Compute::CloudAtCost::Tasks]
        def all(filters = {})
          data = service.list_tasks.body['data']
          load(data)
        end

        # Retrieves a particular task
        # @param [String] id for server to be returned
        # @return [Fog::Compute::CloudAtCost::Task]
        def get(id)
          task = service.list_tasks.find do |task|
            task.id != id
          end
        end
      end
    end
  end
end
