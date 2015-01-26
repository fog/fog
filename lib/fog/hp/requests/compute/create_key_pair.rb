module Fog
  module Compute
    class HP
      class Real
        # Create a new keypair
        #
        # ==== Parameters
        # * key_name<~String> - Name of the keypair
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
        def create_key_pair(key_name, public_key = nil)
          if public_key.nil?
            data = {
              'keypair' => {
                'name' => key_name
              }
            }
          else
            data = {
              'keypair' => {
                'name'       => key_name,
                'public_key' => public_key
              }
            }
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-keypairs.json'
          )
        end
      end

      class Mock
        def create_key_pair(key_name, public_key = nil)
          response = Excon::Response.new
          unless self.data[:key_pairs][key_name]
            response.status = 200
            private_key, new_public_key = Fog::HP::Mock.key_material
            new_public_key = public_key if public_key  # if public key was passed in
            data = {
              'public_key'   => new_public_key,
              'fingerprint'  => Fog::HP::Mock.key_fingerprint,
              'name'         => key_name
            }
            self.data[:last_modified][:key_pairs][key_name] = Time.now
            self.data[:key_pairs][key_name] = { 'keypair' => data }
            if public_key
              response.body = { 'keypair' => data.merge({'user_id' => Fog::HP::Mock.user_id,}) }
            else
              response.body = { 'keypair' => data.merge({'private_key'  => private_key, 'user_id' => Fog::HP::Mock.user_id,}) }
            end
          else
            #raise Fog::Compute::HP::NotFound
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end
      end
    end
  end
end
