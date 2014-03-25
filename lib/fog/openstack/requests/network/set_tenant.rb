module Fog
  module Network
    class OpenStack

      class Real
        def set_tenant(tenant)
          @openstack_must_reauthenticate = true
          @openstack_tenant = tenant.to_s
          authenticate
        end
      end

      class Mock
        def set_tenant(tenant)
          true
        end
      end

    end
  end
end
