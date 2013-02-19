require 'fog/core/model'

module Fog
  module Bluebox
    class BLB

      class LbService < Fog::Model
        identity :id
        
        attribute :name
        attribute :port
        attribute :backends
        attribute :private

        attribute :status_url
        attribute :status_username
        attribute :status_password
        attribute :created,     :aliases => 'created_at'

      end

      def lb_application
        collection.lb_application
      end

    end
  end
end
