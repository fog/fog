require 'fog/core/model'

module Fog
  module DNS
    class StormOnDemand

      class Record < Fog::Model
        identity :id
        attribute :adminEmail
        attribute :expiry
        attribute :fullData
        attribute :minimum
        attribute :name
        attribute :nameserver
        attribute :port
        attribute :prio
        attribute :rdata
        attribute :refreshInterval
        attribute :regionOverrides
        attribute :retry
        attribute :serial
        attribute :target
        attribute :ttl
        attribute :type
        attribute :weight
        attribute :zone_id

        def initialize(attributes={})
          super
        end

        def destroy
          requires :identity
          service.delete_record(:id => identity)
          true
        end

        def update(options={})
          requires :identity
          service.update_record({:id => identity}.merge!(options))
          true
        end

      end

    end
  end
end
