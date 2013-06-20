require 'fog/core/collection'
require 'fog/vcloudng/models/compute/task'

module Fog
  module Compute
    class Vcloudng

      class Tasks < Fog::Collection
        model Fog::Compute::Vcloudng::Task
        
        

        
        def all
          
        end
        
      end
    end
  end
end