require 'fog/core/model'

module Fog
  module DNS
    class Slicehost

      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :id

        attribute :active
        attribute :value,       :aliases => 'ip'
        attribute :name
        attribute :description, :aliases => 'aux'
        attribute :ttl
        attribute :type,        :aliases => 'record_type'
        attribute :zone_id

        def initialize(attributes={})
          self.active ||= true
          self.ttl    ||= 3600
          super
        end

        def active=(new_active)
          attributes[:active] = case new_active
          when false, 'N'
            false
          when true, 'Y'
            true
          end
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
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :name, :type, :value, :zone
          options = {}
          options[:active]  = active ? 'Y' : 'N'
          options[:aux]     = description if description
          options[:ttl]     = ttl if ttl
          data = connection.create_record(type, zone.id, name, value, options)
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
