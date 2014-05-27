module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists dedicated hosts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listDedicatedHosts.html]
        def list_dedicated_hosts(options={})
          options.merge!(
            'command' => 'listDedicatedHosts'  
          )
          request(options)
        end
      end

    end
  end
end

