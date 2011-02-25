require 'fog/core/model'

module Fog
  module DNSimple
    class DNS

      class Record < Fog::Model

        identity :id

        attribute :name
        attribute :ip,          :aliases => "content"
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
          requires :name, :type, :ip
          options = {}
          options[:prio] = priority if priority
          options[:ttl]  = ttl if ttl
          data = connection.create_record(zone.domain, name, type, ip, options)
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
