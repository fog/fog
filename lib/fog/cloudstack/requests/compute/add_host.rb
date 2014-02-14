  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds a new host.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addHost.html]
          def add_host(options={})
            options.merge!(
              'command' => 'addHost'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
