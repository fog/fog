  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Upgrades domain router to a new service offering
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/changeServiceForRouter.html]
          def change_service_for_router(options={})
            options.merge!(
              'command' => 'changeServiceForRouter'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
