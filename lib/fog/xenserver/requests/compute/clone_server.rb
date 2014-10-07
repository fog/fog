module Fog
  module Compute
    class XenServer
      class Real
        def clone_server( server_name, template_ref )
          # Clone the VM template
          if template_ref.kind_of? Fog::Compute::XenServer::Server
            template_ref = template_ref.reference
          end
          raise ArgumentError.new("Invalid template_ref") if template_ref.nil?
          raise ArgumentError.new("Invalid template_ref") if server_name.nil?

          ref = @connection.request(
            {:parser => Fog::Parsers::XenServer::Base.new, :method => 'VM.clone'},
            template_ref, server_name
          )
        end
      end

      class Mock
        def clone_server( server_name, template_ref )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
