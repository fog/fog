module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists hosts.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listHosts.html]
        def list_hosts(options={})
          options.merge!(
            'command' => 'listHosts'
          )
          
          request(options)
        end

      end
    end
  end
end
