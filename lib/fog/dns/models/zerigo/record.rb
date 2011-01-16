require 'fog/core/model'

module Fog
  module Zerigo
    class DNS

      class Record < Fog::Model

        identity :id

        attribute :created_at,  :aliases => 'created-at'
        attribute :ip,          :aliases => 'data'
        attribute :domain,      :aliases => 'fqdn'
        attribute :name,        :aliases => 'hostname'
        attribute :description, :aliases => 'notes'
        attribute :priority
        attribute :ttl
        attribute :type,        :aliases => 'host-type'
        attribute :updated_at,  :aliases => 'updated-at'
        attribute :zone_id,     :aliases => 'zone-id'

        def initialize(attributes={})
          self.ttl    ||= 3600
          super
        end

        def destroy
          requires :identity
          connection.delete_host(identity)
          true
        end

        def zone
          @zone
        end

        def save
          requires :zone, :type, :ip
          options = {}
          options[:hostname]  = name if name
          options[:notes]     = description if description
          options[:priority]  = priority if priority
          options[:ttl]       = ttl if ttl
          data = unless identity
            connection.create_host(@zone.id, type, ip, options)
          else
            options[:host_type] = type
            options[:data]      = data
            connection.update_host(identity, options)
          end
          merge_attributes(data.body)
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
