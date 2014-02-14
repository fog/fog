  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates traffic type of a physical network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateTrafficType.html]
          def update_traffic_type(options={})
            options.merge!(
              'command' => 'updateTrafficType'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
