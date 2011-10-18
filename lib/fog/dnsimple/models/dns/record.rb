require 'fog/core/model'

module Fog
  module DNS
    class DNSimple

      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :id

        attribute :name
        attribute :value,       :aliases => "content"
        attribute :ttl
        attribute :created_at
        attribute :updated_at
        attribute :zone_id,     :aliases => "domain_id"
        attribute :type,        :aliases => "record_type"
        attribute :priority,    :aliases => "prio"

        def initialize(attributes={})
          self.ttl ||= 3600
          super
        end

        def destroy
          connection.delete_record(zone.domain, identity)
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
            data = connection.create_record(zone.domain, name, type, value, options)
          else
            options[:name] = name if name
            options[:content] = value if value
            options[:type] = type if type
            data = connection.update_record(zone.domain, id, options)
          end
          
          merge_attributes(data.body["record"])
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
