require 'fog/compute/models/server'

module Fog
  module Compute
    class XenServer

      class Server < Fog::Compute::Server
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=VM

        identity :reference

        attribute :uuid
        attribute :name,                 :aliases => :name_label
        attribute :__affinity,           :aliases => :affinity
        attribute :allowed_operations
        attribute :consoles
        attribute :domarch
        attribute :domid
        attribute :tags
        attribute :__guest_metrics,      :aliases => :guest_metrics
        attribute :is_a_snapshot
        attribute :is_a_template
        attribute :is_control_domain
        attribute :memory_dynamic_max
        attribute :memory_dynamic_min
        attribute :memory_static_max
        attribute :memory_static_min
        attribute :memory_target
        attribute :metrics
        attribute :name_description
        attribute :other_config
        attribute :power_state
        attribute :pv_args,              :aliases => :PV_args
        attribute :pv_bootloader,        :aliases => :PV_bootloader
        attribute :pv_bootloader_args,   :aliases => :PV_bootloader_args
        attribute :pv_kernel,            :aliases => :PV_kernel
        attribute :pv_ramdisk,           :aliases => :PV_ramdisk
        attribute :pv_legacy_args,       :aliases => :PV_legacy_args
        attribute :__resident_on,        :aliases => :resident_on
        # Virtual Block Devices
        attribute :__vbds,               :aliases => :VBDs
        # Virtual CPUs
        attribute :vcpus_at_startup,     :aliases => :VCPUs_at_startup
        attribute :vcpus_max,            :aliases => :VCPUs_max
        attribute :vcpus_params,         :aliases => :VCPUs_params
        # Virtual Interfaces (NIC)
        attribute :__vifs,               :aliases => :VIFs
        attribute :template_name
        attribute :hvm_boot_policy,      :aliases => :HVM_boot_policy
        attribute :hvm_boot_params,      :aliases => :HVM_boot_params
        attribute :pci_bus,              :aliases => :PCI_bus

        def initialize(attributes={})
          super
        end

        def vbds
          __vbds.collect {|vbd| service.vbds.get vbd }
        end

        def affinity
          service.hosts.get __affinity
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
          data = service.get_record( reference, 'VM' )
          merge_attributes( data )
          true
        end

        def vifs
          __vifs.collect { |vif| service.vifs.get vif }
        end

        # associations
        def networks
          vifs.collect { |v| v.network }
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

        # def snapshot
        #   requires :reference, :name_label
        #   data = service.snapshot_server(@reference, @name_label)
        #   merge_attributes(data.body)
        #   true
        # end
      end

    end
  end
end
