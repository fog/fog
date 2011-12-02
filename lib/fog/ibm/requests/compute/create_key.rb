module Fog
  module Compute
    class IBM
      class Real

        # Create a key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
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
            private_key = Fog::IBM::Mock.key_material
            public_key  = private_key.public_key
            public_key  = { "keyMaterial" => public_key.to_s  }.merge(attributes.dup)
            self.data[:keys][name] = public_key
            private_key = { "keyMaterial" => private_key.to_s }.merge(attributes.dup)
            self.data[:private_keys][name] = private_key
            response.body = private_key
          end
          response
        end

      end
    end
  end
end
