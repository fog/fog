require 'fog/core/model'

module Fog
  module Bluebox
    class BLB
      class LbService < Fog::Model
        identity :id

        attribute :name
        attribute :port
        attribute :service_type
        attribute :private

        attribute :status_url
        attribute :status_username
        attribute :status_password
        attribute :created,     :aliases => 'created_at'

        def lb_application
          collection.lb_application
        end

        def lb_backends
          Fog::Bluebox::BLB::LbBackends.new({
            :service => service,
            :lb_service => self
          })
        end
      end
    end
  end
end
