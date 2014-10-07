module Fog
  module Compute
    class Cloudstack

      class Real
        # add a baremetal host
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addBaremetalHost.html]
        def add_baremetal_host(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addBaremetalHost') 
          else
            options.merge!('command' => 'addBaremetalHost', 
            'podid' => args[0], 
            'url' => args[1], 
            'hypervisor' => args[2], 
            'username' => args[3], 
            'zoneid' => args[4], 
            'password' => args[5])
          end
          request(options)
        end
      end

    end
  end
end

