require 'fog/compute'
require 'azure'

module Fog
  module Compute
    class Azure < Fog::Service

      requires  :azure_sub_id
      requires  :azure_pem

      request_path 'fog/azure/requests/compute'
      request :list_virtual_machines

      model_path 'fog/azure/models/compute'
      model :server
      collection :servers

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
            cfg.management_endpoint = "https://management.core.windows.net"
          end
          @vm_svc = ::Azure::VirtualMachineManagementService.new
        end
      end

    end
  end
end
