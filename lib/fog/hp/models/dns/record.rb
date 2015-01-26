require 'fog/core/model'

module Fog
  module HP
    class DNS
      class Record < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :domain_id
        attribute :type
        attribute :ttl
        attribute :data
        attribute :priority
        attribute :created_at
        attribute :updated_at

        def initialize(new_attributes = {})
          super(new_attributes)
          self.domain_id = domain.id if domain
          self
        end

        def destroy
          requires :id, :domain_id
          service.delete_record(self.domain_id, id)
          true
        end

        def save
          identity ? update : create
        end

        private

        def domain
          collection.domain
        end

        def create
          requires :domain_id
          ### Inconsistent API behavior - does not return 'record'
          merge_attributes(service.create_record(self.domain_id, self.name, self.type, self.data, attributes).body)
          true
        end

        def update
          requires :id, :domain_id
          ### Inconsistent API behavior - does not return 'record'
          merge_attributes(service.update_record(self.domain_id, id, attributes).body)
          true
        end
      end
    end
  end
end
