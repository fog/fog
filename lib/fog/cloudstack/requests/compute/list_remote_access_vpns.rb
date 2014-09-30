module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists remote access vpns
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listRemoteAccessVpns.html]
        def list_remote_access_vpns(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listRemoteAccessVpns') 
          else
            options.merge!('command' => 'listRemoteAccessVpns')
          end
          request(options)
        end
      end

    end
  end
end

