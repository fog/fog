  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists implementors of implementor of a network traffic type or implementors of all network traffic types
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listTrafficTypeImplementors.html]
          def list_traffic_type_implementors(options={})
            options.merge!(
              'command' => 'listTrafficTypeImplementors'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
