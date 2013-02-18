require 'fog/core/collection'

module Fog
  module Bluebox
    class BLB
      class LbServices < Fog::Collection

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
