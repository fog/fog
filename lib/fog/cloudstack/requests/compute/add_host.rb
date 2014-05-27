module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a new host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addHost.html]
        def add_host(options={})
          options.merge!(
            'command' => 'addHost', 
            'podid' => options['podid'], 
            'password' => options['password'], 
            'username' => options['username'], 
            'hypervisor' => options['hypervisor'], 
            'zoneid' => options['zoneid'], 
            'url' => options['url']  
          )
          request(options)
        end
      end

    end
  end
end

