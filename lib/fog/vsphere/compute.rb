require 'digest/sha2'
require 'time'
require_relative './vsphere_connection'

module Fog
  module Compute
    class Vsphere < Fog::Service

      requires :vsphere_server
      recognizes :vsphere_username, :vsphere_password
      recognizes :vsphere_port, :vsphere_path, :vsphere_ns
      recognizes :vsphere_rev, :vsphere_ssl, :vsphere_expected_pubkey_hash
      recognizes :cert, :key, :extension_key

      model_path 'fog/vsphere/models/compute'
      model :server
      collection :servers

      request_path 'fog/vsphere/requests/compute'
      request :current_time
      request :find_vm_by_ref
      request :list_virtual_machines
      request :vm_power_off
      request :vm_power_on
      request :vm_reboot
      request :vm_clone
      request :vm_create
      request :vm_create_disk
      request :vm_destroy
      request :vm_migrate
      request :datacenters
      request :vm_reconfig_hardware
      request :vm_reconfig_memory
      request :vm_reconfig_cpus
      request :vm_config_ip
      request :vm_config_ha
      request :vm_folder
      request :vm_update_network
      request :query_resources
      request :utility


      module Shared

        attr_reader :vsphere_is_vcenter
        attr_reader :vsphere_rev
        attr_reader :vsphere_server
        attr_reader :vsphere_username

        ATTR_TO_PROP = {
            :id => 'config.instanceUuid',
            :name => 'name',
            :uuid => 'config.uuid',
            :instance_uuid => 'config.instanceUuid',
            :hostname => 'summary.guest.hostName',
            :operatingsystem => 'summary.guest.guestFullName',
            :ipaddress => 'guest.ipAddress',
            :power_state => 'runtime.powerState',
            :connection_state => 'runtime.connectionState',
            :hypervisor => 'runtime.host',
            :tools_state => 'guest.toolsStatus',
            :tools_version => 'guest.toolsVersionStatus',
            :is_a_template => 'config.template',
            :memory_mb => 'config.hardware.memoryMB',
            :cpus   => 'config.hardware.numCPU',
        }

        VM_ATTR_TO_PROP = {
            :id => 'config.instanceUuid',
            :name => 'name',
            :uuid => 'config.uuid',
            :instance_uuid => 'config.instanceUuid',
            :hostname => 'summary.guest.hostName',
            :operatingsystem => 'summary.guest.guestFullName',
            :ipaddress => 'guest.ipAddress',
            :power_state => 'runtime.powerState',
            :connection_state => 'runtime.connectionState',
            :hypervisor => 'runtime.host',
            :tools_state => 'guest.toolsStatus',
            :tools_version => 'guest.toolsVersionStatus',
            :is_a_template => 'config.template',
            :max_cpu => 'summary.runtime.maxCpuUsage',
            :max_mem => 'summary.runtime.maxMemoryUsage'
        }

        DC_ATTR_TO_PROP = {
            :name => 'name'
        }

        CS_ATTR_TO_PROP = {
            :name => 'name',
            :eff_mem => 'summary.effectiveMemory',
            :max_mem =>'summary.totalMemory'
        }

        DS_ATTR_TO_PROP = {
            :name => 'name',
            :freeSpace => 'summary.freeSpace',
            :capacity => 'summary.capacity'
        }

        RP_ATTR_TO_PROP = {
            :name => 'name',
            :limit_cpu => 'config.cpuAllocation.limit',
            :limit_mem => 'config.memoryAllocation.limit',
            :shares => 'config.memoryAllocation.shares.shares',
            :config_mem => 'summary.configuredMemoryMB',
            :rev_used_mem => 'summary.runtime.memory.reservationUsed',
            :used_cpu => 'summary.quickStats.overallCpuUsage',
            :host_used_mem => 'summary.quickStats.hostMemoryUsage',
            :guest_used_mem => 'summary.quickStats.guestMemoryUsage'
        }

        HS_ATTR_TO_PROP = {
            :name => 'name',
            :total_memory => 'summary.hardware.memorySize',
            :cpu_num => 'summary.hardware.numCpuCores',
            :cpu_mhz =>'summary.hardware.cpuMhz',
            :used_cpu => 'summary.quickStats.overallCpuUsage',
            :used_mem => 'summary.quickStats.overallMemoryUsage',
            :connection_state =>  'summary.runtime.connectionState'
        }

        def ct_mob_ref_to_attr_hash(mob_ref, attr_s)
          return nil unless mob_ref && attr_s

          attr = case attr_s
                   when "DC"
                     DC_ATTR_TO_PROP
                   when "DS"
                     DS_ATTR_TO_PROP
                   when "HS"
                     HS_ATTR_TO_PROP
                   when "RP"
                     RP_ATTR_TO_PROP
                   when "CS"
                     CS_ATTR_TO_PROP
                   else
                     VM_ATTR_TO_PROP
                 end

          props = mob_ref.collect! *attr.values.uniq
          Hash[attr.map { |k,v| [k.to_s, props[v]] }].tap do |attrs|
            attrs['id'] ||= mob_ref._ref
            attrs['mo_ref'] ||= mob_ref._ref
          end
        end

        # Utility method to convert a VMware managed object into an attribute hash.
        # This should only really be necessary for the real class.
        # This method is expected to be called by the request methods
        # in order to massage VMware Managed Object References into Attribute Hashes.
        def convert_vm_mob_ref_to_attr_hash(vm_mob_ref)
          return nil unless vm_mob_ref

          props = vm_mob_ref.collect! *ATTR_TO_PROP.values.uniq
          # NOTE: Object.tap is in 1.8.7 and later.
          # Here we create the hash object that this method returns, but first we need
          # to add a few more attributes that require additional calls to the vSphere
          # API. The hypervisor name and mac_addresses attributes may not be available
          # so we need catch any exceptions thrown during lookup and set them to nil.
          #
          # The use of the "tap" method here is a convenience, it allows us to update the
          # hash object without explicitly returning the hash at the end of the method.
          Hash[ATTR_TO_PROP.map { |k,v| [k.to_s, props[v]] }].tap do |attrs|
            attrs['id'] ||= vm_mob_ref._ref
            attrs['mo_ref'] = vm_mob_ref._ref
            # The name method "magically" appears after a VM is ready and
            # finished cloning.
            if attrs['hypervisor'].kind_of?(RbVmomi::VIM::HostSystem) then
              # If it's not ready, set the hypervisor to nil
              attrs['hypervisor'] = attrs['hypervisor'].name rescue nil
            end
            # This inline rescue catches any standard error.  While a VM is
            # cloning, a call to the macs method will throw and NoMethodError
            attrs['mac_addresses'] = vm_mob_ref.macs rescue nil
            attrs['path'] = get_folder_path(vm_mob_ref.parent)
          end
        end

      end

      class Mock

        include Shared

        def initialize(options={})
          require 'rbvmomi'
          @vsphere_username = options[:vsphere_username]
          @vsphere_password = 'REDACTED'
          @vsphere_server   = options[:vsphere_server]
          @vsphere_expected_pubkey_hash = options[:vsphere_expected_pubkey_hash]
          @vsphere_is_vcenter = true
          @vsphere_rev = '4.0'
        end

      end

      class Real

        include Shared

        def initialize(options={})
          Fog::Logger.open
          @connection = Fog::VsphereConnection.connect options
        end

        def close
          @connection.close
          @connection = nil
        rescue RbVmomi::fault => e
          raise Fog::Vsphere::Errors::ServiceError, e.message
        end

      end

    end
  end
end
