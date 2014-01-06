require 'fog/core/collection'
require 'fog/xenserver/models/compute/server_appliance'

module Fog
  module Compute
    class XenServer
      class ServerAppliances < Fog::Collection
        model Fog::Compute::XenServer::ServerAppliance

        def all(options={})
          data = service.get_records 'VM_appliance'
          load(data)
        end

        def get( server_appliance_ref )
          if server_appliance_ref && server_appliance = service.get_record( server_appliance_ref, 'VM_appliance' )
            new(server_appliance)
          else
            nil
          end
        end
      end
    end
  end
end
