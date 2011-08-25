require 'fog/core/model'

module Fog
  module DNS
    class Bluebox

      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :id

        attribute :name
        attribute :domain_id,   :aliases => 'domain-id'
        attribute :domain
        attribute :type
        attribute :value,       :aliases => 'content'

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
          requires :zone, :type, :name, :value
          data = unless identity
            connection.create_record(zone.identity, type, name, value)
          else
            connection.update_record(zone.identity, identity, {:type => type, :name => name, :content => value})
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
