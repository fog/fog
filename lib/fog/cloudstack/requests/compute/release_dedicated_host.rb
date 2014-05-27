module Fog
  module Compute
    class Cloudstack

      class Real
        # Release the dedication for host
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/releaseDedicatedHost.html]
        def release_dedicated_host(options={})
          options.merge!(
            'command' => 'releaseDedicatedHost', 
            'hostid' => options['hostid']  
          )
          request(options)
        end
      end

    end
  end
end

