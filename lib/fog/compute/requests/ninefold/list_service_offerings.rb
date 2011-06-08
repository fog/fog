module Fog
  module Ninefold
    class Compute
      class Real

        def list_service_offerings(options = {})
          request('listServiceOfferings', options, :expects => [200],
                  :response_prefix => 'listserviceofferingsresponse/serviceoffering', :response_type => Array)
        end

      end
    end
  end
end
