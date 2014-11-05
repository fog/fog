module Fog
  module Compute
    class Azure
      class Real
        def create_storage_account(name, options)
          @stg_svc.create_storage_account(name, options)
        end
      end

      class Mock
        def create_storage_account(name, options)
        end
      end
    end
  end
end
