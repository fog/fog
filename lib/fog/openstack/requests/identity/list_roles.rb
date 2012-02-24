module Fog
  module Identity
    class OpenStack
      class Real

        def list_roles
          request(
            :expects => 200,
            :method => 'GET',
            :path   => '/OS-KSADM/roles'
          )
        end

      end

      class Mock

        def list_roles
          response = Excon::Response.new
          response.status = 200
          response.body = { 'roles' => self.data[:roles] }
          response
        end

      end
    end
  end
end

