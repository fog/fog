module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal host
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBaremetalHost.html]
        def add_baremetal_host(options={})
          options.merge!(
            'command' => 'addBaremetalHost', 
            'username' => options['username'], 
            'zoneid' => options['zoneid'], 
            'password' => options['password'], 
            'podid' => options['podid'], 
            'hypervisor' => options['hypervisor'], 
            'url' => options['url']  
          )
          request(options)
        end
      end

    end
  end
end

