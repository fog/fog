require "fog/core/collection"
require "fog/azure/models/compute/storage_account"

module Fog
  module Compute
    class Azure
      class StorageAccounts < Fog::Collection
        model Fog::Compute::Azure::StorageAccount

        def all()
          accounts = []
          service.list_storage_accounts.each do |account|
            hash = {}
            account.instance_variables.each do |var|
              hash[var.to_s.delete("@")] = account.instance_variable_get(var)
            end
            accounts << hash
          end
          load(accounts)
        end

        def get(identity)
          all.find { |f| f.name == identity }
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
