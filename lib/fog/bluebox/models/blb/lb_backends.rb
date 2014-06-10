require 'fog/core/collection'
require 'fog/bluebox/models/blb/lb_backend'

module Fog
  module Bluebox
    class BLB
      class LbBackends < Fog::Collection
        model Fog::Bluebox::BLB::LbBackend

        attr_accessor :lb_service

        def all
          data = service.get_lb_backends(lb_service.id).body
          load(data)
        end

        def get(lb_backend_id)
          if lb_backend = service.get_lb_backend(lb_service.id, lb_backend_id).body
            new(lb_backend)
          end
        rescue Fog::Compute::Bluebox::NotFound
          nil
        end
      end
    end
  end
end
