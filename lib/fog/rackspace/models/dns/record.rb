require 'fog/core/model'
require 'fog/rackspace/models/dns/callback'

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
          wait_for_job connection.remove_record(@zone.identity, identity).body['jobId']
          true
        end

        def zone
          @zone
        end

        def save
          if identity
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

          response = wait_for_job connection.add_records(@zone.identity, [options]).body['jobId']
          merge_attributes(response.body['response']['records'].select {|record| record['name'] == self.name && record['type'] == self.type && record['data'] == self.value}.first)
          true
        end

        def update
          requires :identity, :zone

          options = {}
          options[:name] = name if name
          options[:type] = type if type
          options[:data] = value if value
          options[:priority] = priority if priority

          wait_for_job connection.modify_record(@zone.identity, identity, options).body['jobId']
          true
        end

        def zone=(new_zone)
          @zone = new_zone
        end

      end
    end
  end
end
