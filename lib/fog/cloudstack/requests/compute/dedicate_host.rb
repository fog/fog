module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicateHost.html]
        def dedicate_host(options={})
          options.merge!(
            'command' => 'dedicateHost', 
            'hostid' => options['hostid'], 
            'domainid' => options['domainid']  
          )
          request(options)
        end
      end

    end
  end
end

