require 'fog/core/model'

module Fog
  module Bluebox
    class BLB
      class LbApplication < Fog::Model
        identity :id

        attribute :name
        attribute :ip_v4
        attribute :ip_v6
        attribute :description
        attribute :created,     :aliases => 'created_at'

        def add_machine(lb_machine_id, options)
          requires :id
          service.add_machine_to_lb_application(id, lb_machine_id, options)
        end

        def lb_services
          Fog::Bluebox::BLB::LbServices.new({
            :service => service,
            :lb_application => self
          })
        end
      end
    end
  end
end
