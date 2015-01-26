module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists OpenDyalight controllers
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listOpenDaylightControllers.html]
        def list_open_daylight_controllers(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listOpenDaylightControllers') 
          else
            options.merge!('command' => 'listOpenDaylightControllers')
          end
          request(options)
        end
      end

    end
  end
end

