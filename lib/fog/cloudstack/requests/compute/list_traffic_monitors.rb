  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # List traffic monitor Hosts.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listTrafficMonitors.html]
          def list_traffic_monitors(options={})
            options.merge!(
              'command' => 'listTrafficMonitors'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
