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
            'url' => options['url'], 
            'zoneid' => options['zoneid'], 
            'podid' => options['podid'], 
            'password' => options['password'], 
            'hypervisor' => options['hypervisor']  
          )
          request(options)
        end
      end

    end
  end
end

