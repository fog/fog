  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists hosts.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listHosts.html]
          def list_hosts(options={})
            options.merge!(
              'command' => 'listHosts'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
