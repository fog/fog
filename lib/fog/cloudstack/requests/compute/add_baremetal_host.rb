module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal host
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalHost.html]
        def add_baremetal_host(options={})
          request(options)
        end


        def add_baremetal_host(podid, url, hypervisor, username, zoneid, password, options={})
          options.merge!(
            'command' => 'addBaremetalHost', 
            'podid' => podid, 
            'url' => url, 
            'hypervisor' => hypervisor, 
            'username' => username, 
            'zoneid' => zoneid, 
            'password' => password  
          )
          request(options)
        end
      end

    end
  end
end

