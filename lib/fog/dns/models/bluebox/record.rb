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
        attribute :ip,          :aliases => 'content'

        def initialize(attributes={})
          super
        end

        def destroy
          requires :identity
          connection.delete_record(@zone.identity, identity)
          true
        end

        def zone
          @zone
        end

        def save
          requires :zone, :type, :name, :ip
          data = unless identity
            connection.create_record(zone.identity, type, name, ip)
          else
            connection.update_record(zone.identity, identity, {:type => type, :name => name, :content => ip})
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
