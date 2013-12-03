require 'fog/core/collection'
require 'fog/xenserver/models/compute/pif'

module Fog
  module Compute
    class XenServer

      class Pifs < Fog::Collection

        model Fog::Compute::XenServer::PIF

        def initialize(attributes)
          super
        end

        def all(options = {})
          data = service.get_records 'PIF'
          load(data)
        end

        def get( ref )
          if ref && obj = service.get_record( ref, 'PIF' )
            new(obj)
          end
        rescue Fog::XenServer::NotFound
          nil
        end

      end

    end
  end
end
