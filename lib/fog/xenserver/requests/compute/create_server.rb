module Fog
  module Compute
    class XenServer
      class Real
        
        def get_vm_by_name(label)
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.get_by_name_label' }, label)
        end
        
        def create_server_raw(config = {})
          config[:name_label] = config[:name] if config[:name]
          config.delete :name
          config[:affinity] = config[:__affinity] if config[:__affinity]
          config.delete :__affinity
          raise ArgumentError.new("Invalid :name_label attribute") \
            if !config[:name_label]
          raise ArgumentError.new("Invalid :affinity attribute") \
            if not config[:affinity]
          config[:affinity] = config[:affinity].reference \
            if config[:affinity].kind_of? Fog::Compute::XenServer::Host
          config.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
          %w{ VCPUs_at_startup 
              VCPUs_max 
              VCPUs_params
              PV_bootloader_args 
              PV_bootloader
              PV_kernel
              PV_ramdisk
              PV_legacy_args
              HVM_boot_params
              HVM_boot_params
          }.each do |k|
            if config[k.downcase.to_sym]
              config[k.to_sym] = config[k.downcase.to_sym]
              config.delete k.downcase.to_sym
            end
          end
          vm_record = {
            :name_label =>              '',
            :name_description =>        'description',
            :user_version =>            '0',
            :affinity =>                '',
            :is_a_template =>           true,
            :auto_power_on =>           false,
            :memory_static_max =>       '536870912',
            :memory_static_min =>       '536870912',
            :memory_dynamic_max =>      '536870912',
            :memory_dynamic_min =>      '536870912',
            :VCPUs_params =>            {},
            :VCPUs_max =>               '1',
            :VCPUs_at_startup =>        '1',
            :actions_after_shutdown =>  'Destroy',
            :actions_after_reboot =>    'Restart',
            :actions_after_crash =>     'Restart',
            :platform =>                { 'nx' => false, 'acpi' => true, 'apic' => 'true', 'pae' => true, 'viridian' => true},
            :platform =>                {},
            :other_config =>            {},
            :pool_name =>               '',
            :PV_bootloader =>           'pygrub', #pvgrub, eliloader
            :PV_kernel =>                '',
            :PV_ramdisk =>              '',
            :PV_args =>                 '-- quiet console=hvc0',
            :PV_bootloader_args =>      '',
            :PV_legacy_args =>          '',
            :HVM_boot_policy =>         '', 
            :HVM_boot_params =>         {},
            :PCI_bus =>                 '',
            :recommendations =>         '',
          }.merge config
          ref = @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.create' }, vm_record)
          ref
        end

        def create_server( name_label, template = nil, networks = [], extra_args = {})
          if !networks.kind_of? Array
            raise "Invalid networks argument"
          end

          if template.kind_of? String
            template_string = template
            # try template by UUID 
            template = servers.templates.find { |s| s.uuid == template_string }
            if template.nil?
              # Try with the template name just in case
              template = servers.get get_vm_by_name(template_string)
            end
          end

          if template.nil?
            raise "Invalid template"
          end

          raise "Template #{template_string} does not exist" if template.allowed_operations.nil?
          raise 'Clone Operation not Allowed' unless template.allowed_operations.include?('clone')

          # Clone the VM template
          ref = clone_server name_label, template.reference
          # Add additional NICs
          networks.each do |n|
            create_vif ref, n.reference
          end
          if !extra_args[:auto_start] == false
            @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.provision'}, ref)
            start_vm( ref ) 
          end
          
          ref
        end
        
      end
      
      class Mock
        
        def create_server( name_label, template = nil, network = nil, extra_args = {})
          Fog::Mock.not_implemented
        end
        
        def create_server_raw(config = {})
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
