require 'fog/core/model'

module Fog
  module DNS
    class AWS

      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :name,           :aliases => ['Name']

        attribute :value,         :aliases => ['ResourceRecords']
        attribute :ttl,           :aliases => ['TTL']
        attribute :type,          :aliases => ['Type']
        attribute :status,        :aliases => ['Status']
        attribute :created_at,    :aliases => ['SubmittedAt']
        attribute :alias_target,  :aliases => ['AliasTarget']
        attribute :change_id,     :aliases => ['Id']

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

        # Returns true if record is insync.  May only be called for newly created or modified records that
        # have a change_id and status set.
        def ready?
          requires :change_id, :status
          status == 'INSYNC'
        end

        def reload
          # If we have a change_id (newly created or modified), then reload performs a get_change to update status.
          if change_id
            data = connection.get_change(change_id).body
            merge_attributes(data)
            self
          else
            super
          end
        end

        private

        def zone=(new_zone)
          @zone = new_zone
        end

        def attributes_to_options(action)
          requires :name, :ttl, :type, :zone
          requires_one :value, :alias_target
          {
            :action           => action,
            :name             => name,
            :resource_records => [*value],
            :alias_target     => symbolize_keys(alias_target),
            :ttl              => ttl,
            :type             => type
          }
        end

      end

    end
  end
end
