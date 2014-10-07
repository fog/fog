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

        def create_region(options)
          requires :identity
          service.create_record_region({:record_id => identity}.merge!(options))
          true
        end

        def delete_region(options)
          requires :identity
          service.delete_record_region({:record_id => identity}.merge!(options))
        end

        def update_region(options)
          requires :identity
          service.update_record_region({:record_id => identity}.merge!(options))
        end
      end
    end
  end
end
