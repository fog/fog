require 'fog/core/collection'
require 'fog/xenserver/models/compute/role'

module Fog
  module Compute
    class XenServer
      class Roles < Fog::Collection
        model Fog::Compute::XenServer::Role

        def all(options={})
          data = service.get_records 'role'
          load(data)
        end

        def get( role_ref )
          if role_ref && role = service.get_record( role_ref, 'role' )
            new(role)
          else
            nil
          end
        end
      end
    end
  end
end
