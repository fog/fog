require 'fog/core/collection'

module Fog
  module Bluebox
    class BLB
      class LbServices < Fog::Collection
        model Fog::Bluebox::BLB::LbService

        def all
          data = service.get_lb_services.body
          load(data)
        end

        def get(server_id)
          if server_id && server = service.get_block(server_id).body
            new(server)
          end
        rescue Fog::Compute::Bluebox::NotFound
          nil
        end

      end

    end
  end
end
