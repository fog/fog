module Fog
  module Compute
    class Azure
      class Real
        def get_storage_account(name)
          @stg_svc.get_storage_account_properties(name)
        end
      end

      class Mock
        def get_storage_account(name)
        end
      end
    end
  end
end
