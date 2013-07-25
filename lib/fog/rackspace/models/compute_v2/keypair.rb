require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class Keypair < Fog::Model
        attribute :public_key
        attribute :private_key
        attribute :user_id
        identity  :name
        attribute :fingerprint

        def save
          requires :name
          data = service.create_keypair(name, public_key)
          merge_attributes(data.body['keypair'])
          data.body['keypair']['name'] == name
        end

        def destroy
          begin
            service.delete_keypair(identity)
          rescue Fog::Compute::RackspaceV2::NotFound
          end
          true
        end

      end
    end
  end
end
