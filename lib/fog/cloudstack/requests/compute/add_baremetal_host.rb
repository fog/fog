module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal host
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalHost.html]
        def add_baremetal_host(zoneid, password, podid, username, hypervisor, url, options={})
          options.merge!(
            'command' => 'addBaremetalHost', 
            'zoneid' => zoneid, 
            'password' => password, 
            'podid' => podid, 
            'username' => username, 
            'hypervisor' => hypervisor, 
            'url' => url  
          )
          request(options)
        end
      end

    end
  end
end

