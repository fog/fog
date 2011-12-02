module Fog
  module Compute
    class IBM
      class Real

        # Get a key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
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
