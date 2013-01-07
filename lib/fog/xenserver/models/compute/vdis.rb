require 'fog/core/collection'
require 'fog/xenserver/models/compute/vdi'

module Fog
  module Compute
    class XenServer

      class Vdis < Fog::Collection

        model Fog::Compute::XenServer::VDI

        def all(options = {})
          data = service.get_records 'VDI'
          load(data)
        end

        def get( vdi_ref )
          if vdi_ref && vdi = service.get_record( vdi_ref, 'VDI' )
            new(vdi)
          end
        rescue Fog::XenServer::NotFound
          nil
        end

      end

    end
  end
end
