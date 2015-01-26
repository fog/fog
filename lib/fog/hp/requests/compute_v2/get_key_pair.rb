module Fog
  module Compute
    class HPV2
      class Real
        # Get details about a key pair
        #
        # ==== Parameters
        # * 'key_name'<~String> - Name of the keypair to get
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'keypair'<~Hash>:
        #     * 'public_key'<~String> - Public portion of the key
        #     * 'name'<~String> - Name of the key
        #     * 'fingerprint'<~String> - Fingerprint of the key
        def get_key_pair(key_name)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "os-keypairs/#{key_name}"
          )
        end
      end

      class Mock
        def get_key_pair(key_name)
          response = Excon::Response.new
          if key_pair = self.data[:key_pairs][key_name]
            response.status = 200
            response.body = { 'keypair' => key_pair['keypair'] }
            response
          else
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
