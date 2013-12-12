require 'fog/core/collection'
require 'fog/xenserver/models/compute/gpu_group'

module Fog
  module Compute
    class XenServer
      class GpuGroups < Fog::Collection
        model Fog::Compute::XenServer::GpuGroup

        def all(options={})
          data = service.get_records 'GPU_group'
          load(data)
        end

        def get( gpu_group_ref )
          if gpu_group_ref && gpu_group = service.get_record( gpu_group_ref, 'GPU_group' )
            new(gpu_group)
          else
            nil
          end
        end
      end
    end
  end
end
