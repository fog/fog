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
          storage = ::Azure::StorageManagement::StorageAccount.new
          storage.name = name
          storage.status = "Created"
          storage.label = name
          storage.location = options[:location]
          storage
        end
      end
    end
  end
end
