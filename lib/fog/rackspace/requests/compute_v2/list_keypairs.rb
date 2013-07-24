module Fog
  module Compute
    class RackspaceV2
      class Real

        # Returns list of instances that the authenticated user manages.
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keypairs'<~Array>: list of keypairs
        #       * 'keypair'<~Hash>: fingerprint, name, public_key
        def list_keypairs
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/os-keypairs'
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
