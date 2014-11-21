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
          storage = ::Azure::StorageManagement::StorageAccount.new
          storage.name = "fogteststorageaccount"
          storage.status = "Created"
          storage.label = "Storage-Name"
          storage.location = "West US"
          [storage]
        end
      end
    end
  end
end
