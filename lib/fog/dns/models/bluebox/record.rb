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
          connection.delete_record(@zone.identity, identity)
          true
        end

        def zone
          @zone
        end

        def save
          requires :zone, :type, :domain, :content
          data = unless identity
            connection.create_record(@zone.id, type, domain, content)
          else
            connection.update_record(identity)
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
