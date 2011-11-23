module Fog
  module Compute
    class HP
      class Real

        # Create a new keypair
        #
        # ==== Parameters
        # * name<~String> - Name of the keypair
        # * public_key<~String> - The public key for the keypair
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keypair'<~Hash> - The keypair data
        #       * 'public_key'<~String> - The public key for the keypair
        #       * 'private_key'<~String> - The private key for the keypair
        #       * 'user_id'<~String> - The user id
        #       * 'fingerprint'<~String> - SHA-1 digest of DER encoded private key
        #       * 'name'<~String> - Name of key
        #
        # {Openstack API Reference}[http://docs.openstack.org]
        def create_key_pair(name, public_key = nil)
          if public_key.nil?
            data = {
              'keypair' => {
                'name' => name
              }
            }
          else
            data = {
              'keypair' => {
                'name'       => name,
                'public_key' => public_key
              }
            }
          end

          request(
            :body     => MultiJson.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-keypairs.json'
          )
        end

      end

      class Mock

        def create_key_pair(key_name)
          response = Excon::Response.new
          unless self.data[:key_pairs][key_name]
            response.status = 200
            private_key, public_key = Fog::HP::Mock.key_material
            data = {
              'keypair' => {
                'public_key'   => public_key,
                'private_key'  => private_key,
                'fingerprint'  => Fog::HP::Mock.key_fingerprint,
                'user_id'      => Fog::HP::Mock.user_id,
                'name'      => key_name
              }
            }
            self.data[:last_modified][:servers][key_name] = Time.now
            self.data[:key_pairs][key_name] = data

            response.body = data
            response
          else
            raise Fog::Compute::HP::Error.new("InvalidKeyPair.Duplicate => The keypair '#{key_name}' already exists.")
          end
        end

      end

    end
  end
end
