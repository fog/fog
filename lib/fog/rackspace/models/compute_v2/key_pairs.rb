require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/key_pair'

module Fog
  module Compute
    class RackspaceV2
      class KeyPairs < Fog::Collection
        model Fog::Compute::RackspaceV2::KeyPair

        # Fetch the list of known keypairs
        # @return [Fog::Compute::RackspaceV2::Keypairs] the retreived keypairs
        # @raise  [Fog::Compute::RackspaceV2::NotFound]
        # @raise  [Fog::Compute::RackspaceV2::BadRequest]
        # @raise  [Fog::Compute::RackspaceV2::InternalServerError]
        # @raise  [Fog::Compute::RackspaceV2::ServiceError]
        def all
          data = []
          service.list_keypairs.body['keypairs'].each do |kp|
            data << kp['keypair'] if kp['keypair']
          end
          load(data)
        end

        # Fetch keypair details
        # @param  [String] key_name name of the key to request
        # @return [Fog::Compute::RackspaceV2::Keypair] the requested keypair or 'nil' when not found
        # @raise  [Fog::Compute::RackspaceV2::BadRequest]
        # @raise  [Fog::Compute::RackspaceV2::InternalServerError]
        # @raise  [Fog::Compute::RackspaceV2::ServiceError]
        def get(key_name)
            begin
                new(service.get_keypair(key_name).body['keypair'])
            rescue Fog::Compute::RackspaceV2::NotFound
                nil
            end
        end
      end
    end
  end
end
