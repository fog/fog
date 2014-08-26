module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes an OpenDyalight controler
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteOpenDaylightController.html]
        def delete_open_daylight_controller(options={})
          request(options)
        end


        def delete_open_daylight_controller(id, options={})
          options.merge!(
            'command' => 'deleteOpenDaylightController', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

