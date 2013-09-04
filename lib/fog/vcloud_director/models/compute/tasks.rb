require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/task'

module Fog
  module Compute
    class VcloudDirector

      class Tasks < Collection
        model Fog::Compute::VcloudDirector::Task
        
        

        
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