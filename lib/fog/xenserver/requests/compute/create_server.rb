module Fog
  module Compute
    class XenServer
      class Real

        def get_vm_by_name(label)
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.get_by_name_label' }, label)
        end
        
        def create_server( name_label, template = nil, network = nil, extra_args = {})
          template ||= default_template
          network ||= default_network
          
          if template.nil?
            raise "Invalid template"
          end

          if template.kind_of? String
            template_string = template
            template = servers.get get_vm_by_name(template_string)
          end

          #FIXME: need to check that template exist actually
          raise "Template #{template_string} does not exist" if template.allowed_operations.nil?
          raise 'Clone Operation not Allowed' unless template.allowed_operations.include?('clone')

          # Clone the VM template
          @connection.request(
            {:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.clone'}, 
            template.reference, name_label
          )
          new_vm = servers.get get_vm_by_name( name_label )

          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.provision'}, new_vm.reference)
          start_vm( new_vm.reference ) unless extra_args[:auto_start] == false
          
          new_vm
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
