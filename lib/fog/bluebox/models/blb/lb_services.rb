require 'fog/core/collection'
require 'fog/bluebox/models/blb/lb_service'

module Fog
  module Bluebox
    class BLB
      class LbServices < Fog::Collection
        model Fog::Bluebox::BLB::LbService

        def all
          data = service.get_lb_services.body
          load(data)
        end

        def get(application_id, service_id)
          if service_id && service = service.get_lb_services(service_id).body
            new(server)
          end
        rescue Fog::Bluebox::BLB::NotFound
          nil
        end

      end

    end
  end
end
