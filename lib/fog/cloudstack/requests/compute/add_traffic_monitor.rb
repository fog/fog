  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds Traffic Monitor Host for Direct Network Usage
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addTrafficMonitor.html]
          def add_traffic_monitor(options={})
            options.merge!(
              'command' => 'addTrafficMonitor'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
