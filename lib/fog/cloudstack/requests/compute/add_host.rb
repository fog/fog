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
            'password' => options['password'], 
            'podid' => options['podid'], 
            'zoneid' => options['zoneid'], 
            'url' => options['url'], 
            'username' => options['username'], 
            'hypervisor' => options['hypervisor'], 
             
          )
          request(options)
        end
      end

    end
  end
end

