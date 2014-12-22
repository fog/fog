require 'fog/compute/models/server'

module Fog
  module Compute
    class XenServer
      class Server < Fog::Compute::Server
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=VM

        identity :reference

        attribute :uuid
        attribute :name,                        :aliases => :name_label
        attribute :description,                 :aliases => :name_description
        attribute :__affinity,                  :aliases => :affinity
        attribute :actions_after_crash
        attribute :actions_after_reboot
        attribute :actions_after_shutdown
        attribute :allowed_operations
        attribute :__consoles,                  :aliases => :consoles
        attribute :__attached_pcis,             :aliases => :attached_PCIs
        attribute :bios_strings
        attribute :blobs
        attribute :blocked_operations
        attribute :__children,                  :aliases => :children
        attribute :__crash_dumps,               :aliases => :crash_dumps
        attribute :current_operations
        attribute :domarch
        attribute :domid
        attribute :generation_id
        attribute :tags
        attribute :__guest_metrics,             :aliases => :guest_metrics
        attribute :ha_always_run
        attribute :ha_restart_priority
        attribute :is_a_snapshot
        attribute :is_a_template
        attribute :is_control_domain
        attribute :is_snapshot_from_vmpp
        attribute :last_boot_cpu_flags,         :aliases => :last_boot_CPU_flags
        attribute :last_booted_record
        attribute :memory_dynamic_max
        attribute :memory_dynamic_min
        attribute :memory_overhead
        attribute :memory_static_max
        attribute :memory_static_min
        attribute :memory_target
        attribute :__metrics,                   :aliases => :metrics
        attribute :order
        attribute :other_config
        attribute :__parent,                    :aliases => :parent
        attribute :platform
        attribute :power_state
        attribute :protection_policy
        attribute :pv_args,                     :aliases => :PV_args
        attribute :pv_bootloader,               :aliases => :PV_bootloader
        attribute :pv_bootloader_args,          :aliases => :PV_bootloader_args
        attribute :pv_kernel,                   :aliases => :PV_kernel
        attribute :pv_ramdisk,                  :aliases => :PV_ramdisk
        attribute :pv_legacy_args,              :aliases => :PV_legacy_args
        attribute :recommendations
        attribute :__resident_on,               :aliases => :resident_on
        attribute :shutdown_delay
        attribute :snapshot_info
        attribute :snapshot_metadata
        attribute :__snapshot_of,               :aliases => :snapshot_of
        attribute :snapshot_time
        attribute :start_delay
        attribute :__suspend_sr,                :aliases => :suspend_sr
        attribute :__suspend_vdi,               :aliases => :suspend_VDI
        attribute :transportable_snapshot_id
        attribute :user_version
        attribute :version
        attribute :__vgpus,                     :aliases => :VGPUs
        attribute :__vtpms,                     :aliases => :VTPMs
        attribute :xenstore_data
        # Virtual Block Devices
        attribute :__vbds,                      :aliases => :VBDs
        # Virtual CPUs
        attribute :vcpus_at_startup,            :aliases => :VCPUs_at_startup
        attribute :vcpus_max,                   :aliases => :VCPUs_max
        attribute :vcpus_params,                :aliases => :VCPUs_params
        # Virtual Interfaces (NIC)
        attribute :__vifs,                      :aliases => :VIFs
        attribute :template_name
        attribute :hvm_boot_policy,             :aliases => :HVM_boot_policy
        attribute :hvm_boot_params,             :aliases => :HVM_boot_params
        attribute :hvm_shadow_multiplier,       :aliases => :HVM_shadow_multiplier
        attribute :pci_bus,                     :aliases => :PCI_bus
        attribute :snapshots

        def vbds
          __vbds.map {|vbd| service.vbds.get vbd }
        end

        def affinity
          service.hosts.get __affinity
        end

        def consoles
          __consoles.map {|console| service.consoles.get console }
        end

        def destroy
          # Make sure it's halted
          stop('hard')
          vbds.each do |vbd|
            if vbd.type == "Disk"
              vbd.unplug \
                if vbd.allowed_operations.include?("unplug")
              vbd.vdi.destroy \
                if vbd.vdi.allowed_operations.include?("destroy")
            end
          end
          service.destroy_server( reference )
          true
        end

        def set_attribute(name, *val)
          data = service.set_attribute( 'VM', reference, name, *val )
          # Do not reload automatically for performance reasons
          # We can set multiple attributes at the same time and
          # then reload manually
          #reload
        end

        def refresh
          Fog::Logger.deprecation(
              'This method is deprecated. Use #reload instead.'
          )
          data = service.get_record( reference, 'VM' )
          merge_attributes( data )
          true
        end

        def vifs
          __vifs.map { |vif| service.vifs.get vif }
        end

        # associations
        def networks
          vifs.map { |v| v.network }
        end

        def resident_on
          service.hosts.get __resident_on
        end

        #
        # This is not always present in XenServer VMs
        # Guest needs XenTools installed to report this AFAIK
        def guest_metrics
          return nil unless __guest_metrics
          rec = service.get_record( __guest_metrics, 'VM_guest_metrics' )
          Fog::Compute::XenServer::GuestMetrics.new(rec)
        end

        def tools_installed?
          !guest_metrics.nil?
        end

        def home_hypervisor
          service.hosts.first
        end

        def mac_address
          networks.first.MAC
        end

        def running?
          reload
          power_state == "Running"
        end

        def halted?
          reload
          power_state == "Halted"
        end

        # operations
        def start
          return false if running?
          service.start_server( reference )
          true
        end

        def save(params = {})
          requires :name
          nets = attributes[:networks] || []
          if params[:auto_start].nil?
            auto_start = true
          else
            auto_start = params[:auto_start]
          end
          if template_name
            attr = service.get_record(
              service.create_server( name, template_name, nets, :auto_start => auto_start),
              'VM'
            )
          else
            attr = service.get_record(
              service.create_server_raw(attributes),
              'VM'
            )
          end
          merge_attributes attr
          true
        end

        def reboot(stype = 'clean')
          service.reboot_server(reference, stype)
          true
        end

        def hard_reboot
          reboot 'hard'
        end

        def clean_reboot
          reboot 'clean'
        end

        def stop(stype = 'clean')
          return false if !running?
          service.shutdown_server( reference, stype )
          wait_for { power_state == 'Halted' }
          true
        end

        def hard_shutdown
          stop 'hard'
        end

        def clean_shutdown
          stop 'clean'
        end

        def provision
          service.provision_server reference
        end

        def snapshot(name)
          service.snapshot_server(reference, name)
        end

        def revert(snapshot_ref)
          service.snapshot_revert(snapshot_ref)
        end
      end
    end
  end
end
