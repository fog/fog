require 'fog/core/collection'
require 'fog/vcloudng/models/compute/task'

module Fog
  module Compute
    class Vcloudng

      class Tasks < Fog::Collection
        model Fog::Compute::Vcloudng::Task
        
        

        
        def all
          
        end
        
        def get(id)
          data = service.get_task(id).body
          return nil unless data
          data[:id] = data[:href].split('/').last
          new(data)
        end
        
      end
    end
  end
end