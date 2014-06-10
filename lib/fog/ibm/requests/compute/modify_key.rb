module Fog
  module Compute
    class IBM
      class Real
        # Modify a key
        #
        # ==== Parameters
        # * key_name<~String> - name of key to be modified
        # * params<~Hash> - depends on type of request
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'success'<~Bool>: success status of update request
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
          if key_exists? key_name
            if params['public_key']
              self.data[:keys][key_name]['keyMaterial'] = public_key
              self.data[:keys][key_name]['lastModifiedTime'] = Fog::IBM::Mock.launch_time
            end
            if params['default']
              self.data[:keys].values.each do |key|
                key['default'] = false
              end
              self.data[:keys][key_name]['default'] = true
            end
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
