module Fog
  module Compute
    class RackspaceV2
      class Real

        # Returns details of key by name specified
        #
        # ==== Parameters
        # 'key_name'<~String>: name of key to request
        #         
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keypair'<~Hash>: Name of key
        #       * 'public_key'<~String>: public key
        #       * 'name'<~String>: key name
        #       * 'fingerprint'<~String>: id
        #
        def get_key(key_name)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/os-keypairs/#{key_name}"
          )
        end
      end
    end
  end
end
