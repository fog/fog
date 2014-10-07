module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists hosts.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listHosts.html]
        def list_hosts(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listHosts') 
          else
            options.merge!('command' => 'listHosts')
          end
          request(options)
        end
      end

    end
  end
end

