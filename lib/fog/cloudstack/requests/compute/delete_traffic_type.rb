  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes traffic type of a physical network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteTrafficType.html]
          def delete_traffic_type(options={})
            options.merge!(
              'command' => 'deleteTrafficType'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
