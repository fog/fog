module Fog
  module Rackspace
    class Networking
      class Network < Fog::Model
        identity :id

        attribute :label
        attribute :cidr

        def save
          requires :label, :cidr

          data = service.create_network(label, cidr)
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
