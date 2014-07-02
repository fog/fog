module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Ucs manager
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addUcsManager.html]
        def add_ucs_manager(zoneid, url, password, username, options={})
          options.merge!(
            'command' => 'addUcsManager', 
            'zoneid' => zoneid, 
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

