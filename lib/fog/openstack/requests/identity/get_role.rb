module Fog
  module Identity
    class OpenStack
      class Real
        def get_role(id)
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "/OS-KSADM/roles/%s" % id
          )
        end
      end

      class Mock
        def get_role(id)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
            'role' => {
              'id' => '1',
              'name' => 'System Admin',
              'description' => 'Role description',
            }
          }
          response
        end
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
