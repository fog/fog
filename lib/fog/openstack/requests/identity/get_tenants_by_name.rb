module Fog
  module Identity
    class OpenStack
      class Real
        def get_tenants_by_name(name)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "tenants?name=#{name}"
          )
        end
      end

      class Mock
      end
    end
  end
end
