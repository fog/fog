module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicateHost.html]
        def dedicate_host(hostid, domainid, options={})
          options.merge!(
            'command' => 'dedicateHost', 
            'hostid' => hostid, 
            'domainid' => domainid  
          )
          request(options)
        end
      end

    end
  end
end

