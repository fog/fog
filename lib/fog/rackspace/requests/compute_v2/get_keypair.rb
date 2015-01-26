module Fog
  module Compute
    class RackspaceV2
      class Real
        # Retreive single keypair details
        # @param [String] key_name name of the key for which to request the details
        # @return  [Excon::Response] response :
        #   * body [Hash]: -
        #     * 'keypair' [Hash]: -
        #       * 'fingerprint' [String]: unique fingerprint of the keypair
        #       * 'name' [String]: unique name of the keypair
        #       * 'public_key' [String]: the public key assigne to the keypair
        # @raise [Fog::Compute::RackspaceV2::NotFound]
        # @raise [Fog::Compute::RackspaceV2::BadRequest]
        # @raise [Fog::Compute::RackspaceV2::InternalServerError]
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see   http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ListKeyPairs.html
        def get_keypair(key_name)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/os-keypairs/#{key_name}"
          )
        end
      end

      class Mock
        def get_keypair(key_name)
            key = self.data[:keypairs].select { |k| key_name.include? k['keypair']['name'] }.first
            if key.nil?
                raise Fog::Compute::RackspaceV2::NotFound
            end

            response(:body => key, :status => 200)
        end
      end
    end
  end
end
