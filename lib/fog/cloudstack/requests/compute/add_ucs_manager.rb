module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Ucs manager
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addUcsManager.html]
        def add_ucs_manager(options={})
          options.merge!(
            'command' => 'addUcsManager', 
            'url' => options['url'], 
            'password' => options['password'], 
            'username' => options['username'], 
            'zoneid' => options['zoneid']  
          )
          request(options)
        end
      end

    end
  end
end

