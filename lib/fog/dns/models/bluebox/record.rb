require 'fog/core/model'

module Fog
  module Bluebox
    class DNS

      class Record < Fog::Model

        identity :id

        attribute :name
        attribute :domain_id,   :aliases => 'domain-id'
        attribute :domain
        attribute :type
        attribute :content

        def initialize(attributes={})
          super
        end

        def destroy
          requires :identity
          connection.delete_record(identity)
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
            connection.create_record(@zone.id, type, ip, options)
          else
            options[:host_type] = type
            options[:data]      = data
            connection.update_record(identity, options)
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
