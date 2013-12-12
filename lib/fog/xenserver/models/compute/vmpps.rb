require 'fog/core/collection'
require 'fog/xenserver/models/compute/vmpp'

module Fog
  module Compute
    class XenServer
      class Vmpps < Fog::Collection
        model Fog::Compute::XenServer::Vmpp

        def all(options={})
          data = service.get_records 'VMPP'
          load(data)
        end

        def get( vmpp_ref )
          if vmpp_ref && vmpp = service.get_record( vmpp_ref, 'VMPP' )
            new(vmpp)
          else
            nil
          end
        end
      end
    end
  end
end
