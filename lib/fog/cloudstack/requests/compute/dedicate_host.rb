module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/dedicateHost.html]
        def dedicate_host(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'dedicateHost') 
          else
            options.merge!('command' => 'dedicateHost', 
            'hostid' => args[0], 
            'domainid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

