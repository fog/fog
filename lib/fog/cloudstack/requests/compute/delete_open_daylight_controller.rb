module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes an OpenDyalight controler
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteOpenDaylightController.html]
        def delete_open_daylight_controller(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteOpenDaylightController') 
          else
            options.merge!('command' => 'deleteOpenDaylightController', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

