require 'fog/core/model'
require 'fog/rackspace/models/dns/callback'
require 'ipaddr'

module Fog
  module DNS
    class Rackspace
      class Record < Fog::Model
        include Fog::DNS::Rackspace::Callback
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :id

        attribute :name
        attribute :value,       :aliases => 'data'
        attribute :ttl
        attribute :type
        attribute :priority
        attribute :created
        attribute :updated

        def destroy
          requires :zone, :identity
          wait_for_job service.remove_record(@zone.identity, identity).body['jobId']
          true
        end

        def zone
          @zone
        end

        def save
          if persisted?
            update
          else
            create
          end
        end

        private

        def create
          requires :name, :type, :value, :zone

          options = {
            :name => name,
            :type => type,
            :data => value
          }

          if ttl
            options[:ttl] = ttl
          end

          if priority
            options[:priority] = priority
          end

          response = wait_for_job service.add_records(@zone.identity, [options]).body['jobId']

          matching_record = response.body['response']['records'].find do |record|
            if ['A', 'AAAA'].include?(self.type.upcase)
              # If this is an A or AAAA record, match by normalized IP address value.
              (record['name'] == self.name) && (record['type'] == self.type) && (IPAddr.new(record['data']) == IPAddr.new(self.value))
            else
              # Other record types are matched by the raw value.
              (record['name'] == self.name) && (record['type'] == self.type) && (record['data'] == self.value)
            end
          end

          merge_attributes(matching_record)

          true
        end

        def update
          requires :identity, :zone

          options = {}
          options[:name] = name if name
          options[:type] = type if type
          options[:data] = value if value
          options[:priority] = priority if priority
          options[:ttl] = ttl if ttl

          wait_for_job service.modify_record(@zone.identity, identity, options).body['jobId']
          true
        end

        def zone=(new_zone)
          @zone = new_zone
        end
      end
    end
  end
end
