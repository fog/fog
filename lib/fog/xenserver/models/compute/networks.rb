require 'fog/core/collection'
require 'fog/xenserver/models/compute/network'

module Fog
  module Compute
    class XenServer

      class Networks < Fog::Collection

        model Fog::Compute::XenServer::Network
        
        def initialize(attributes)
          super
        end

        def all(options = {})
          data = connection.get_records 'network'
          load(data)
        end

        def get( ref )
          if ref && obj = connection.get_record( ref, 'network' )
            new(obj)
          end
        rescue Fog::XenServer::NotFound
          nil
        end

      end

    end
  end
end
