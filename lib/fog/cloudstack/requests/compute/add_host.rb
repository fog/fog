module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a new host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addHost.html]
        def add_host(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addHost') 
          else
            options.merge!('command' => 'addHost', 
            'url' => args[0], 
            'zoneid' => args[1], 
            'username' => args[2], 
            'password' => args[3], 
            'hypervisor' => args[4], 
            'podid' => args[5])
          end
          request(options)
        end
      end

    end
  end
end

