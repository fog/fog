module Fog
  module Compute
    class XenServer
      class Real
        
        require 'fog/xenserver/parsers/get_vms'

        def get_vm_by_name(label)
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.get_by_name_label' }, label)
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

          #FIXME: need to check that template exist actually
          raise "Template #{template_string} does not exist" if template.allowed_operations.nil?
          raise 'Clone Operation not Allowed' unless template.allowed_operations.include?('clone')

          # Clone the VM template
          ref = @connection.request(
            {:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.clone'}, 
            template.reference, name_label
          )
          networks.each do |n|
            create_vif ref, n.reference
          end
          #new_vm = servers.get get_vm_by_name( name_label )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.provision'}, ref)
          start_vm( ref ) unless extra_args[:auto_start] == false
          
          ref
        end
        
      end
      
      class Mock
        
        def create_server( name_label, template = nil, network = nil, extra_args = {})
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
