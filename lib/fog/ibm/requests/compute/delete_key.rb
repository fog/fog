module Fog
  module Compute
    class IBM
      class Real
        # Deletes the key specified with key_name
        #
        # ==== Parameters
        # * key_name<~String> - name of key to be deleted
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     *'success'<~Bool>: true or false for success
        def delete_key(key_name)
          request(
            :method   => 'DELETE',
            :expects  => 200,
            :path     => "/keys/#{key_name}"
          )
        end
      end
      class Mock
        def delete_key(key_name)
          response = Excon::Response.new
          if key_exists? key_name
            self.data[:keys].delete(key_name)
            response.status = 200
            response.body = {"success"=>true}
          else
            response.status = 404
          end
          response
        end
      end
    end
  end
end
