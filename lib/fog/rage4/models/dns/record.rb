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
        attribute :priority,    :aliases => "prio"

        def initialize(attributes={})
          super
        end

        def destroy
          service.delete_record(identity)
          true
        end

        def zone
          @zone
        end

        def save
          requires :name, :type, :value
          options = {}
          options[:prio] = priority if priority
          options[:ttl]  = ttl if ttl

          # decide whether its a new record or update of an existing
          if id.nil?
            data = service.create_record(zone.id, name, value, type, options)
          else
            data = service.update_record(id, name, value, type, options)
          end

          merge_attributes(options)
          merge_atributes(:name =>  name, :value => value, :type => type)
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
