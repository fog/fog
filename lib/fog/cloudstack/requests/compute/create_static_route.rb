  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a static route
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createStaticRoute.html]
          def create_static_route(options={})
            options.merge!(
              'command' => 'createStaticRoute'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
