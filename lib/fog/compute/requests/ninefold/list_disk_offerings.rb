module Fog
  module Ninefold
    class Compute
      class Real

        def list_disk_offerings(options = {})
          request('listDiskOfferings', options, :expects => [200],
                  :response_prefix => 'listdiskofferingsresponse/diskoffering', :response_type => Array)
        end

      end
    end
  end
end
