require 'fog/core/model'

module Fog
  module DNS
    class Zerigo
      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :id

        attribute :created_at,  :aliases => 'created-at'
        attribute :value,       :aliases => 'data'
        attribute :domain,      :aliases => 'fqdn'
        attribute :name,        :aliases => 'hostname'
        attribute :description, :aliases => 'notes'
        attribute :priority
        attribute :ttl
        attribute :type,        :aliases => 'host-type'
        attribute :updated_at,  :aliases => 'updated-at'
        attribute :zone_id,     :aliases => 'zone-id'

        def initialize(attributes={})
          super
        end

        def destroy
          requires :identity
          service.delete_host(identity)
          true
        end

        def zone
          @zone
        end

        def save
          requires :zone, :type, :value
          options = {}
          options[:hostname]  = name if name
          options[:notes]     = description if description
          options[:priority]  = priority if priority
          options[:ttl]       = ttl if ttl

          if persisted?
            options[:host_type] = type
            options[:data]      = value
            service.update_host(identity, options)
          else
            data = service.create_host(@zone.id, type, value, options)
            merge_attributes(data.body)
          end

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
