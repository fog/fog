module Fog
  module Compute
    class RackspaceV2
      class Real
        # Returns a list of all key pairs associated with an account.
        # @return  [Excon::Response] response :
        #   * body [Hash]: -
        #     * 'keypairs' [Array]: list of keypairs
        #       * 'keypair' [Hash]: -
        #           * 'fingerprint' [String]: unique fingerprint of the keypair
        #           * 'name' [String]: unique name of the keypair
        #           * 'public_key' [String]: the public key assigned to the keypair
        # @raise [Fog::Compute::RackspaceV2::NotFound]
        # @raise [Fog::Compute::RackspaceV2::BadRequest]
        # @raise [Fog::Compute::RackspaceV2::InternalServerError]
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see   http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ListKeyPairs.html
        def list_keypairs
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => 'os-keypairs'
          )
        end
      end

      class Mock
        def list_keypairs
            response( :status => 200,
                      :body   => { 'keypairs' => self.data[:keypairs] })
        end
      end
    end
  end
end
