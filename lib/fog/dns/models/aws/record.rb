require 'fog/core/model'

module Fog
  module DNS
    class AWS

      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :id,           :aliases => ['Id']

        attribute :value,       :aliases => ['ResourceRecords']
        attribute :name,        :aliases => ['Name']
        attribute :ttl,         :aliases => ['TTL']
        attribute :type,        :aliases => ['Type']
        attribute :status,      :aliases => ['Status']
        attribute :created_at,  :aliases => ['SubmittedAt']

        def initialize(attributes={})
          self.ttl ||= 3600
          super
        end

        def destroy
          requires :name, :ttl, :type, :value, :zone
          options = {
            :action           => 'DELETE',
            :name             => name,
            :resource_records => [*value],
            :ttl              => ttl,
            :type             => type
          }
          connection.change_resource_record_sets(zone.id, [options])
          true
        end

        def zone
          @zone
        end

        def save
          requires :name, :ttl, :type, :value, :zone
          options = {
            :action           => 'CREATE',
            :name             => name,
            :resource_records => [*value],
            :ttl              => ttl,
            :type             => type
          }
          data = connection.change_resource_record_sets(zone.id, [options]).body
          merge_attributes(data)
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
