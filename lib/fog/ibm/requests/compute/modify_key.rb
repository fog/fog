module Fog
  module Compute
    class IBM
      class Real

        # Modify a key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def modify_key(key_name, params={})
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/keys/#{key_name}",
            :body     => params
          )
        end

      end
      class Mock

        def modify_key(key_name, params={})
          response = Excon::Response.new
          if params['public_key']
            if key_exists? key_name
              self.data[:keys][key_name]['keyMaterial'] = public_key
              self.data[:keys][key_name]['lastModifiedTime'] = Fog::IBM::Mock.launch_time,
              response.status = 200
              response.body = {"success"=>true}
            else
              response.status = 404
            end
          else
            Fog::Mock.not_implemented
          end
          response
        end

      end
    end
  end
end
