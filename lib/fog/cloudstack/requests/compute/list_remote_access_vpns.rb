module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists remote access vpns
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listRemoteAccessVpns.html]
        def list_remote_access_vpns(publicipid, options={})
          options.merge!(
            'command' => 'listRemoteAccessVpns', 
            'publicipid' => publicipid  
          )
          request(options)
        end
      end

    end
  end
end

