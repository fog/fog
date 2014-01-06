require 'fog/core/collection'
require 'fog/xenserver/models/compute/host_patch'

module Fog
  module Compute
    class XenServer
      class HostPatchs < Fog::Collection
        model Fog::Compute::XenServer::HostPatch

        def all(options={})
          data = service.get_records 'host_patch'
          load(data)
        end

        def get( host_patch_ref )
          if host_patch_ref && host_patch = service.get_record( host_patch_ref, 'host_patch' )
            new(host_patch)
          else
            nil
          end
        end
      end
    end
  end
end
