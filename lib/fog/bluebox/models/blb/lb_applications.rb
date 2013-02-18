require 'fog/core/collection'

module Fog
  module Bluebox
    class BLB
      class LbApplications < Fog::Collection
        model Fog::Bluebox::BLB::LbApplication

        def all
          data = service.get_lb_applications.body
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
