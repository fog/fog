module Fog
  module Compute
    class Cloudstack
      class Real

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
