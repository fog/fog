  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists traffic types of a given physical network.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listTrafficTypes.html]
          def list_traffic_types(options={})
            options.merge!(
              'command' => 'listTrafficTypes'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
