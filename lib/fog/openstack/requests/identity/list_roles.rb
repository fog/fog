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
          if self.data[:roles].empty?
            ['admin', 'Member'].each do |name|
              id = Fog::Mock.random_hex(32)
              self.data[:roles][id] = {'id' => id, 'name' => name}
            end
          end

          Excon::Response.new(
            :body   => { 'roles' => self.data[:roles].values },
            :status => 200
          )
        end
      end
    end
  end
end
