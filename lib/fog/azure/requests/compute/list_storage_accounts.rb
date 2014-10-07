module Fog
  module Compute
    class Azure

      class Real

        def list_storage_accounts
          @stg_svc.list_storage_accounts
        end

      end

      class Mock

        def list_storage_accounts
        end

      end

    end
  end
end
