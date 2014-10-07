module Fog
  module Compute
    class Cloudstack

      class Real
        # Release the dedication for host
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/releaseDedicatedHost.html]
        def release_dedicated_host(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'releaseDedicatedHost') 
          else
            options.merge!('command' => 'releaseDedicatedHost', 
            'hostid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

