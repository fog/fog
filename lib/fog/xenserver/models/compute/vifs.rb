require 'fog/core/collection'
require 'fog/xenserver/models/compute/vif'

module Fog
  module Compute
    class XenServer

      class Vifs < Fog::Collection

        model Fog::Compute::XenServer::VIF
        
        def all(options = {})
          data = connection.get_records 'VIF'
          load(data)
        end

        def get( ref )
          if ref && obj = connection.get_record( ref, 'VIF' )
            new(obj)
          end
        rescue Fog::XenServer::NotFound
          nil
        end

      end

    end
  end
end
