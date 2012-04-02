module Fog
  module Compute
    class XenServer
      class Real
        
        def create_vm( name_label, template = nil, network = nil, extra_args = {})
          template ||= default_template
          network ||= default_network
          
          if template.nil?
            raise "Invalid template"
          end

          if template.kind_of? String
            data = get_vm( template )
            template_string = template
            template = Fog::Compute::XenServer::Server.new(data)
          end

          begin
            #FIXME: need to check that template exist actually
            raise "Template #{template_string} does not exist" if template.allowed_operations.nil?
            raise 'Clone Operation not Allowed' unless template.allowed_operations.include?('clone')

            # Clone the VM template
            @connection.request(
              {:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.clone'}, 
              template.reference, name_label
            )
            new_vm = Fog::Compute::XenServer::Server.new get_vm( name_label )

            # Not required
            #@connection.request(
            #  {:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.set_affinity'}, 
            #  new_vm.reference, hosts.all.first.reference
            #)

            #
            # Create VIF
            #create_vif( new_vm.reference, network.reference )
            
           # raise Fog::XenServer::OperationFailed unless new_vm.allowed_operations.include?('provision')
            @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.provision'}, new_vm.reference)
            start_vm( new_vm.reference ) unless extra_args[:auto_start] == false
            
            new_vm
          rescue => e
            puts e.message
            puts e.backtrace
            puts "ERROR"
          end
        end
        
      end
      
      class Mock
        
        def create_vm()
          Fog::Mock.not_implemented
        end
        
      end

    end
  end
end
