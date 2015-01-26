require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class KeyPair < Fog::Model
        # @!attribute [rw] name
        # @return [String] the keypair name
        identity  :name

        # @!attribute [r]  public_key
        # @return [String] the public key
        attribute :public_key

        # @!attribute [r]  private_key
        # @return [String] the private key
        attribute :private_key

        # @!attribute [r]  user_id
        # @return [String] the user_id associated to
        attribute :user_id

        # @!attribute [r]  fingerprint
        # @return [String] unique fingerprint
        attribute :fingerprint

        # Creates a keypair
        # @return [Boolean] true if the keypair is successfully created
        # @raise  [Fog::Compute::RackspaceV2::NotFound]
        # @raise  [Fog::Compute::RackspaceV2::BadRequest]
        # @raise  [Fog::Compute::RackspaceV2::InternalServerError]
        # @raise  [Fog::Compute::RackspaceV2::ServiceError]
        def save
          requires :name
          data = service.create_keypair(name, attributes)
          merge_attributes(data.body['keypair'])
          data.body['keypair']['name'] == name
        end

        # Destroys a keypair
        # @return [Boolean] true if the keypair is successfully deleted
        # @raise  [Fog::Compute::RackspaceV2::NotFound]
        # @raise  [Fog::Compute::RackspaceV2::BadRequest]
        # @raise  [Fog::Compute::RackspaceV2::InternalServerError]
        # @raise  [Fog::Compute::RackspaceV2::ServiceError]
        def destroy
            requires :identity
            service.delete_keypair(identity)
            true
        end
      end
    end
  end
end
