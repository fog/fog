require 'fog/core/model'

module Fog
  module DNS
    class AWS

      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :name,         :aliases => ['Name']

        attribute :value,       :aliases => ['ResourceRecords']
        attribute :ttl,         :aliases => ['TTL']
        attribute :type,        :aliases => ['Type']
        attribute :status,      :aliases => ['Status']
        attribute :created_at,  :aliases => ['SubmittedAt']

        def initialize(attributes={})
          self.ttl ||= 3600
          super
        end

        def destroy
          options = attributes_to_options('DELETE')
          connection.change_resource_record_sets(zone.id, [options])
          true
        end

        def zone
          @zone
        end

        def save
          options = attributes_to_options('CREATE')
          data = connection.change_resource_record_sets(zone.id, [options]).body
          merge_attributes(data)
          true
        end

        def modify(new_attributes)
          options = []

          # Delete the current attributes
          options << attributes_to_options('DELETE')

          # Create the new attributes
          merge_attributes(new_attributes)
          options << attributes_to_options('CREATE')

          data = connection.change_resource_record_sets(zone.id, options).body
          merge_attributes(data)
          true
        end

        private

        def zone=(new_zone)
          @zone = new_zone
        end

        def attributes_to_options(action)
          requires :name, :ttl, :type, :value, :zone
          {
            :action           => action,
            :name             => name,
            :resource_records => [*value],
            :ttl              => ttl,
            :type             => type
          }
        end

      end

    end
  end
end
