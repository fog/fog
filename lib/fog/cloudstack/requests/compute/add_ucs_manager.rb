module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Ucs manager
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addUcsManager.html]
        def add_ucs_manager(options={})
          request(options)
        end


        def add_ucs_manager(url, password, username, zoneid, options={})
          options.merge!(
            'command' => 'addUcsManager', 
            'url' => url, 
            'password' => password, 
            'username' => username, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

