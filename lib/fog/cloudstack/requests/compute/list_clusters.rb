module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists configurations and provides detailed account information for listed configurations.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listAccounts.html]
        def list_clusters(options={})
          options.merge!(
            'command' => 'listClusters'
          )
          
          request(options)
        end

      end
    end
  end
end
