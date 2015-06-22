module Fog
  module Identity
    class OpenStack
      class V2
        class Real
          def list_roles(options = {})
            request(
                :expects => 200,
                :method  => 'GET',
                :path    => '/OS-KSADM/roles',
                :query   => options
            )
          end
        end

        class Mock
          def list_roles(options = {})
            if self.data[:roles].empty?
              ['admin', 'Member'].each do |name|
                id = Fog::Mock.random_hex(32)
                self.data[:roles][id] = {'id' => id, 'name' => name}
              end
            end

            Excon::Response.new(
                :body => {'roles' => self.data[:roles].values},
                :status => 200
            )
          end
        end
      end # class V2
    end
  end
end
