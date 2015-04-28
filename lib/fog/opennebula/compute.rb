require 'fog/opennebula/core'

module Fog
 module Compute
  class OpenNebula < Fog::Service
      requires   :opennebula_endpoint
      recognizes :opennebula_username, :opennebula_password

      model_path 'fog/opennebula/models/compute'
      model       :server
      collection  :servers
      model       :network
      collection  :networks
      model       :flavor
      collection  :flavors
      model       :interface
      collection  :interfaces
      model       :group
      collection  :groups

      request_path 'fog/opennebula/requests/compute'
      request :list_vms
      request :list_groups
      request :list_networks
      request :vm_allocate
      request :vm_destroy
      request :get_vnc_console
      request :vm_resume
      request :vm_stop
      request :template_pool
      request :vm_disk_snapshot
      request :vm_shutdown
      request :image_pool

    class Mock
      include Collections
      def initialize(options={})
        require 'opennebula'
      end

      def client
        return @client
      end
    end

    class Real
      include Collections

      def client
        return @client
      end

      def initialize(options={})
        require 'opennebula'
        @client = ::OpenNebula::Client.new("#{options[:opennebula_username]}:#{options[:opennebula_password]}", options[:opennebula_endpoint])
      end
    end
  end
 end
end
