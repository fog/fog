require 'fog/core/collection'
require 'fog/xenserver/models/compute/pool'

module Fog
  module Compute
    class XenServer

      class Pools < Fog::Collection

        model Fog::Compute::XenServer::Pool
        
        def initialize(attributes)
          super
        end

        def all(options = {})
          data = connection.get_pools
          load(data)
        end

        def get( pool_ref )
          if pool_ref && pool = connection.get_pool_by_ref( pool_ref )
            new(pool)
          end
        rescue Fog::XenServer::NotFound
          nil
        end

      end

    end
  end
end
