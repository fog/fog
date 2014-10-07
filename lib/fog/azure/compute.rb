require 'fog/compute'
require 'fog/azure/core'
require 'azure'

module Fog
  module Compute
    class Azure < Fog::Service

      requires  :azure_sub_id
      requires  :azure_pem

      request_path 'fog/azure/requests/compute'
      request :list_virtual_machines
      request :create_virtual_machine
      request :delete_virtual_machine
      request :get_storage_account
      request :create_storage_account
      request :list_storage_accounts
      request :delete_storage_account

      model_path 'fog/azure/models/compute'
      model :server
      collection :servers
      model :storage_account
      collection :storage_accounts

      class Mock
        include Collections
        def initialize(options)
          @vm_svc = nil
        end
      end

      class Real
        include Collections
        def initialize(options)
          ::Azure.configure do |cfg|
            cfg.management_certificate = options[:azure_pem]
            cfg.subscription_id = options[:azure_sub_id]
            cfg.management_endpoint = "https://management.core.windows.net" #fix to use option if available
          end
          @vm_svc = ::Azure::VirtualMachineManagementService.new
          @stg_svc = ::Azure::StorageManagementService.new
        end
      end

    end
  end
end
