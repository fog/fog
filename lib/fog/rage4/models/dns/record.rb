require 'fog/core/model'

module Fog
  module DNS
    class Rage4
      class Record < Fog::Model
        identity :id

        attribute :name
        attribute :value,       :aliases => "content"
        attribute :ttl
        attribute :zone_id,     :aliases => "domain_id"
        attribute :type,        :aliases => "record_type"
        attribute :priority,    :aliases => "priority"
        attribute :domain_id
        attribute :geo_region_id
        attribute :failover_enabled
        attribute :failover_content
        attribute :geo_lat
        attribute :geo_long
        attribute :geo_lock
        attribute :is_active
        attribute :udp_limit

        def initialize(attributes={})
          super
        end

        def domain
          name
        end

        def destroy
          service.delete_record(id)
          true
        end

        def zone
          @zone
        end

        def save
          requires :name, :type, :value
          options = {}
          options[:priority] = priority if priority
          options[:ttl]  = ttl if ttl
          options[:geozone] = geo_region_id if geo_region_id
          options[:geolock] = geo_lock if geo_lock
          options[:geolat] = geo_lat if geo_lat
          options[:geolong] = geo_long if geo_long
          options[:udplimit] = udp_limit if udp_limit

          # decide whether its a new record or update of an existing
          if id.nil?
            data = service.create_record(zone.id, name, value, type, options)
          else
            data = service.update_record(id, name, value, type, options)
          end

          merge_attributes(options)
          merge_attributes(:name =>  name, :value => value, :type => type)
          true
        end

        private

        def zone=(new_zone)
          @zone = new_zone
        end
      end
    end
  end
end
