module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists dedicated hosts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listDedicatedHosts.html]
        def list_dedicated_hosts(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listDedicatedHosts') 
          else
            options.merge!('command' => 'listDedicatedHosts')
          end
          request(options)
        end
      end

    end
  end
end

