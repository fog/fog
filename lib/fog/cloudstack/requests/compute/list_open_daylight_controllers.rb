module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists OpenDyalight controllers
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listOpenDaylightControllers.html]
        def list_open_daylight_controllers(options={})
          request(options)
        end


        def list_open_daylight_controllers(options={})
          options.merge!(
            'command' => 'listOpenDaylightControllers'  
          )
          request(options)
        end
      end

    end
  end
end

