module Fog
  module Compute
    class IBM
      class Real

        # Requests a new keypair to be created
        #
        # ==== Parameters
        # * name<~String> - name to give new key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keyName'<~String>: name of new key
        #     * 'lastModifiedTime'<~Integer>: epoch time of last modification
        #     * 'default'<~Bool>: is default?
        #     * 'instanceIds'<~Array>: id's of instances using key (should be empty upon creation)
        #     * 'keyMaterial'<~String>: private key contents
        def create_key(name, public_key=nil)
          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => '/keys',
            :body => {
              'name' => name,
              'publicKey' => public_key
            }
          )
        end

      end

      class Mock

        # SmartCloud returns the private key when create_key is called
        # We need to store both the private and public key for later use
        def create_key(name, public_key=nil)
          response = Excon::Response.new
          response.status = 200
          attributes  = {
            "keyName"           => name,
            "lastModifiedTime"  => Fog::IBM::Mock.launch_time,
            "default"           => false,
            "instanceIds"       => [],
          }
          if public_key.nil?
            private_key   = Fog::IBM::Mock.key_material
            public_key    = private_key.public_key
            response.body = attributes.merge("keyMaterial" => private_key.to_s)
          else
            response.body = { 'success' => true }
          end
          self.data[:keys][name] = attributes.merge("keyMaterial" => public_key.to_s)
          self.data[:private_keys][name] = attributes.merge("keyMaterial" => private_key.to_s)
          response
        end

      end
    end
  end
end
