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
        attribute :notes
        attribute :priority
        attribute :ttl
        attribute :type,        :aliases => 'host-type'
        attribute :updated_at,  :aliases => 'updated-at'
        attribute :zone_id,     :aliases => 'zone-id'

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
          options[:notes]     = notes if notes
          options[:priority]  = priority if priority
          options[:ttl]       = ttl if ttl
          data = connection.create_host(@zone.id, type, ip, options)
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
