module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds an OpenDyalight controler
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addOpenDaylightController.html]
        def add_open_daylight_controller(options={})
          request(options)
        end


        def add_open_daylight_controller(physicalnetworkid, url, password, username, options={})
          options.merge!(
            'command' => 'addOpenDaylightController', 
            'physicalnetworkid' => physicalnetworkid, 
            'url' => url, 
            'password' => password, 
            'username' => username  
          )
          request(options)
        end
      end

    end
  end
end

