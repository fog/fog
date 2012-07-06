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
          Excon::Response.new(
            :body   => { 'roles' => self.data[:roles].values },
            :status => 200
          )
        end

      end
    end
  end
end

