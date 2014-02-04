require 'fog/xenserver/core'
require 'fog/compute'

module Fog
  module Compute
    class XenServer < Fog::Service

      require 'fog/xenserver/utilities'
      require 'fog/xenserver/parser'

      requires :xenserver_username
      requires :xenserver_password
      requires :xenserver_url
      recognizes :xenserver_defaults
      recognizes :xenserver_timeout

      model_path 'fog/xenserver/models/compute'
      model :blob
      collection :blobs
      model :bond
      collection :bonds
      model :crash_dump
      collection :crash_dumps
      model :dr_task
      collection :dr_tasks
      model :gpu_group
      collection :gpu_groups
      model :host_crash_dump
      collection :host_crash_dumps
      model :host_patch
      collection :host_patchs
      model :pci
      collection :pcis
      model :pgpu
      collection :pgpus
      model :pif_metrics
      collection :pifs_metrics
      model :pool_patch
      collection :pool_patchs
      model :role
      collection :roles
      model :server
      collection :servers
      model :server_appliance
      collection :server_appliances
      model :storage_manager
      collection :storage_managers
      model :tunnel
      collection :tunnels
      model :vmpp
      collection :vmpps
      model :vtpm
      collection :vtpms
      model :host
      collection :hosts
      collection :vifs
      model :vif
      collection :storage_repositories
      model :storage_repository
      collection :pools
      model :pool
      collection :vbds
      model :vbd
      collection :vdis
      model :vdi
      collection :networks
      model :network
      collection :pifs
      model  :pif
      collection :pbds
      model  :pbd
      model  :guest_metrics
      model  :vbd_metrics
      model  :host_metrics
      model  :host_cpu
      model  :vlan
      collection :vlans
      model  :console
      collection :consoles

      request_path 'fog/xenserver/requests/compute'
      request :create_server
      request :create_vif
      request :create_vdi
      request :create_vbd
      request :destroy_vif
      request :clone_server
      request :destroy_server
      request :unplug_vbd
      request :eject_vbd
      request :insert_vbd
      request :destroy_vdi
      request :shutdown_server
      request :start_vm
      request :start_server
      request :get_record
      request :get_records
      request :set_affinity
      request :set_attribute
      request :reboot_server
      request :provision_server
      request :scan_sr
      request :unplug_pbd
      request :destroy_sr
      request :create_sr
      request :reboot_host
      request :disable_host
      request :enable_host
      request :shutdown_host
      request :create_network
      request :destroy_network
      request :create_vlan
      request :destroy_vlan
      request :snapshot_server
      request :snapshot_revert

      class Real

        def initialize(options={})
          @host        = options[:xenserver_url]
          @username    = options[:xenserver_username]
          @password    = options[:xenserver_password]
          @defaults    = options[:xenserver_defaults] || {}
          @timeout     = options[:xenserver_timeout] || 30
          @connection  = Fog::XenServer::Connection.new(@host, @timeout)
          @connection.authenticate(@username, @password)
        end

        def reload
          @connection.authenticate(@username, @password)
        end

        def default_template=(name)
          @defaults[:template] = name
        end

        def default_template
          return nil if @defaults[:template].nil?
          (servers.custom_templates + servers.builtin_templates).find do |s|
            (s.name == @defaults[:template]) or (s.uuid == @defaults[:template])
          end
        end

        def default_network
          networks.find { |n| n.name == (@defaults[:network] || "Pool-wide network associated with eth0") }
        end

      end

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @host        = options[:xenserver_pool_master]
          @username    = options[:xenserver_username]
          @password    = options[:xenserver_password]
          @connection  = Fog::Connection.new(@host)
          @connection.authenticate(@username, @password)
        end

      end
    end
  end
end


