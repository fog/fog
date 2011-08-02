module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all available snapshots for the account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listSnapshots.html]
        def list_snapshots(options={})
          options.merge!(
            'command' => 'listSnapshots'
          )
          
          request(options)
        end

      end
    end
  end
end
