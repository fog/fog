module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a new host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addHost.html]
        def add_host(options={})
          request(options)
        end


        def add_host(url, zoneid, username, password, hypervisor, podid, options={})
          options.merge!(
            'command' => 'addHost', 
            'url' => url, 
            'zoneid' => zoneid, 
            'username' => username, 
            'password' => password, 
            'hypervisor' => hypervisor, 
            'podid' => podid  
          )
          request(options)
        end
      end

    end
  end
end

