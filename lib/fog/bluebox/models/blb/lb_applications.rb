require 'fog/bluebox/models/blb/lb_application'

module Fog
  module Bluebox
    class BLB
      class LbApplications < Fog::Collection
        model Fog::Bluebox::BLB::LbApplication

        def all
          data = service.get_lb_applications.body
          load(data)
        end

        def get(application_id)
          if application_id && application = service.get_lb_application(application_id).body
            new(application)
          end
        rescue Fog::Bluebox::BLB::NotFound
          nil
        end
      end
    end
  end
end
