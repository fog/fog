require 'fog/core/model'

module Fog
  module DNS
    class StormOnDemand

      class Zone < Fog::Model
        identity :id
        attribute :active
        attribute :delegation_checked
        attribute :delegation_status
        attribute :master
        attribute :name
        attribute :notified_serial
        attribute :region_support
        attribute :type

        def initialize(attributes={})
          super
        end

        def delegation
          requires :identity
          service.check_zone_delegation(:id => identity).body['delegation']
        end

        def destroy
          requires :identity
          service.delete_zone(:id => identity).body['deleted']
        end

        def update(options={})
          requires :identity
          service.update_zone({:id => identity}.merge!(options))
        end
        
      end
    end
  end
end
