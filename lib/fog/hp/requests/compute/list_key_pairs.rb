module Fog
  module Compute
    class HP
      class Real

        # List all key pairs
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keypairs'<~Array>:
        #       * 'keypair'<~Hash>:
        #         * 'public_key'<~String> - Public portion of the key
        #         * 'name'<~String> - Name of the key
        #         * 'fingerprint'<~String> - Fingerprint of the key
        #
        # {Openstack API Reference}[http://docs.openstack.org]
        def list_key_pairs
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'os-keypairs.json'
          )
        end

      end

      class Mock

        def list_key_pairs
          response = Excon::Response.new

          key_pairs = []
          key_pairs = self.data[:key_pairs].values unless self.data[:key_pairs].nil?

          puts "Key Pairs Raw: #{key_pairs.inspect} "

          response.status = [200, 203][rand(1)]
          response.body = { 'keypairs' => key_pairs.map {|keypair| keypair['keypair'].reject {|key,value| !['public_key', 'name', 'fingerprint'].include?(key)}} }
          response
        end

      end
    end
  end
end
