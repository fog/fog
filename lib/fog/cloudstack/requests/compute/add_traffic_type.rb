  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds traffic type to a physical network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addTrafficType.html]
          def add_traffic_type(options={})
            options.merge!(
              'command' => 'addTrafficType'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
