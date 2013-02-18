require 'fog/core/model'

module Fog
  module Bluebox
    class BLB

      class LbApplication < Fog::Model
        identity :id
        
        attribute :name
        attribute :ip_v4
        attribute :ip_v6
        attribute :services
        attribute :description
        attribute :created,     :aliases => 'created_at'

        def services
          requires :id
          service.get_lb_services(id).body
        end

      end

    end
  end
end
