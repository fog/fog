module Fog
  module Compute
    class Cloudstack

      class Real
        # Upgrades domain router to a new service offering
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/changeServiceForRouter.html]
        def change_service_for_router(options={})
          options.merge!(
            'command' => 'changeServiceForRouter',
            'serviceofferingid' => options['serviceofferingid'], 
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

