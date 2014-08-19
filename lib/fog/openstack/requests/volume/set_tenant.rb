module Fog
  module Volume
    class OpenStack
      class Real
        def set_tenant(tenant)
          @must_reauthenticate = true
          @tenant = tenant.to_s
          authenticate
        end
      end

      class Mock
        def set_tenant(tenant)
          true
        end
      end
    end # class OpenStack
  end # module Volume
end # module Fog
