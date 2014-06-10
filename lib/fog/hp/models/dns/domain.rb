require 'fog/core/model'

module Fog
  module HP
    class DNS
      class Domain < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :email
        attribute :ttl
        attribute :serial
        attribute :created_at
        attribute :updated_at

        def destroy
          requires :id
          service.delete_domain(id)
          true
        end

        def records
          @records ||= begin
            Fog::HP::DNS::Records.new({
              :service  => service,
              :domain   => self
            })
          end
        end

        def save
          identity ? update : create
        end

        private

        def create
          ### Inconsistent API behavior - does not return 'domain'
          merge_attributes(service.create_domain(self.name, self.email, attributes).body)
          true
        end

        def update
          requires :id
          ### Inconsistent API behavior - does not return 'domain'
          merge_attributes(service.update_domain(id, attributes).body)
          true
        end
      end
    end
  end
end
