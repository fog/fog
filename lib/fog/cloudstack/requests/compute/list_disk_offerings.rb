module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all available disk offerings.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listDiskOfferings.html]
        def list_disk_offerings(options={})
          options.merge!(
            'command' => 'listDiskOfferings'
          )
          
          request(options)
        end

      end
    end
  end
end
