module Fog
  module Compute
    class IBM
      class Real
        # Returns details of key by name specified
        #
        # ==== Parameters
        # 'key_name'<~String>: name of key to request
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keyName'<~String>: Name of key
        #     * 'lastModifiedTime'<~Integer>: epoch time of last modification
        #     * 'default'<~Bool>: bool if key is default for user
        #     * 'instanceIds'<~Array>: list of instances associated with key
        #     * 'keyMaterial'<~String>: public key
        def get_key(key_name)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/keys/#{key_name}"
          )
        end
      end

      class Mock
        def get_key(key_name)
          response = Excon::Response.new
          if key_exists? key_name
            response.status = 200
            response.body = self.data[:keys][key_name]
          else
            response.status = 404
          end
          response
        end

        def key_exists?(name)
          self.data[:keys].key? name
        end
      end
    end
  end
end
