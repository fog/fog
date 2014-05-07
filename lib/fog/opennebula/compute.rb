require 'opennebula'
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
#      model       :pool
#      collection  :pools
#      model       :node
#      collection  :nodes
#
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
      #request :define_domain
#      request :vm_action
#      request :list_pools
#      request :list_pool_volumes
#      request :define_pool
#      request :pool_action
#      request :list_volumes
#      request :volume_action
#      request :create_volume
#      request :destroy_network
#      request :list_interfaces
#      request :destroy_interface
#      request :get_node_info
#      request :update_display

    class Mock
      include Collections
    end

    class Real
      include Collections

      def client
        return @client if defined?(@client)
      end

      def initialize(options={})
        @client = ::OpenNebula::Client.new("#{options[:opennebula_username]}:#{options[:opennebula_password]}", options[:opennebula_endpoint])
      end
    end
  end
 end
end
