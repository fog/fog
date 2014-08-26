module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a new host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addHost.html]
        def add_host(hypervisor, zoneid, url, password, podid, username, options={})
          options.merge!(
            'command' => 'addHost', 
            'hypervisor' => hypervisor, 
            'zoneid' => zoneid, 
            'url' => url, 
            'password' => password, 
            'podid' => podid, 
            'username' => username  
          )
          request(options)
        end
      end

    end
  end
end

