  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Returns an encrypted password for the VM
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/getVMPassword.html]
          def get_vmpassword(options={})
            options.merge!(
              'command' => 'getVMPassword'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
