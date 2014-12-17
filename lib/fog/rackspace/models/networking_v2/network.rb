module Fog
  module Rackspace
    class NetworkingV2
      class Network < Fog::Model

        identity :id

        attribute :admin_state_up
        attribute :label
        attribute :name
        attribute :shared
        attribute :status
        attribute :subnets
        attribute :tenant_id

        def save
          data = unless self.id.nil?
            service.update_network(self)
          else
            service.create_network(self)
          end

          merge_attributes(data.body['network'])
          true
        end

        def destroy
          requires :identity

          service.delete_network(identity)
          true
        end
      end
    end
  end
end
