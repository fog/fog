module Fog
  module Compute
    class Azure
      class Real
        def delete_storage_account(name)
          @stg_svc.delete_storage_account(name)
        end
      end

      class Mock
        def delete_storage_account(name)
          nil
        end
      end
    end
  end
end
