module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists remote access vpns
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listRemoteAccessVpns.html]
        def list_remote_access_vpns(options={})
          options.merge!(
            'command' => 'listRemoteAccessVpns', 
            'publicipid' => options['publicipid']  
          )
          request(options)
        end
      end

    end
  end
end

