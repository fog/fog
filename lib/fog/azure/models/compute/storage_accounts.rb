require 'fog/core/collection'
require 'fog/azure/models/compute/storage_account'

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
          account = service.get_storage_account(identity)
          hash = {}
          account.instance_variables.each do |var|
            hash[var.to_s.delete("@")] = account.instance_variable_get(var)
          end
          new(hash)
        end

        def create(new_attributes = {})
          defaults = {
            :name => "fog#{Time.now.to_i}",
            :location => "Central US",
          }
          super(defaults.merge(new_attributes))
        end

      end
    end
  end
end
