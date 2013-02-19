require 'fog/core/collection'
require 'fog/bluebox/models/blb/lb_service'

module Fog
  module Bluebox
    class BLB
      class LbServices < Fog::Collection
        model Fog::Bluebox::BLB::LbService

        attr_accessor :data, :lb_application

        def all
          data = service.get_lb_services(lb_application.id).body
          load(data)
        end

        def get(lb_service_id)
          lb_service = service.get_lb_service(lb_application.id, lb_service_id).body
          new(lb_service)
        rescue Fog::Bluebox::BLB::NotFound
          nil
        end

      end

    end
  end
end
