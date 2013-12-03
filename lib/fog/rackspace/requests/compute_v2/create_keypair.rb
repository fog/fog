module Fog
  module Compute
    class RackspaceV2
      class Real

        # Request a new keypair to be created
        # @param [String] key_name: unique name of the keypair to create
        # @return  [Excon::Response] response :
        #   * body [Hash]: -
        #     * 'keypair' [Hash]: -
        #       * 'fingerprint' [String]: unique fingerprint of the keypair
        #       * 'name' [String]: unique name of the keypair
        #       * 'private_key' [String]: the private key of the keypair (only available here, at creation time)
        #       * 'public_key' [String]: the public key of the keypair
        #       * 'user_id' [String]: the user id
        # @raise [Fog::Compute::RackspaceV2::NotFound]
        # @raise [Fog::Compute::RackspaceV2::BadRequest]
        # @raise [Fog::Compute::RackspaceV2::InternalServerError]
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see   http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateKeyPair.html
        def create_keypair(key_name, public_key=nil)
          data = {
            'keypair' => {
              'name' => key_name
            }
          }

          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => '/os-keypairs',
            :body     => Fog::JSON.encode(data)
          )
        end
      end

      class Mock
        def create_keypair(key_name, public_key=nil)
            # 409 response when already existing
            raise Fog::Compute::RackspaceV2::ServiceError if not self.data[:keypairs].select { |k| key_name.include? k['keypair']['name'] }.first.nil?

            k = self.data[:keypair]
            k['name'] = key_name
            self.data[:keypairs] << { 'keypair' => k }

            response( :status => 200,
                      :body   => { 'keypair' => k } )
        end
      end

    end
  end
end
