module Fog
  module Compute
    class Cloudstack

      class Real
        # Upgrades domain router to a new service offering
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/changeServiceForRouter.html]
        def change_service_for_router(serviceofferingid, id, options={})
          options.merge!(
            'command' => 'changeServiceForRouter', 
            'serviceofferingid' => serviceofferingid, 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

