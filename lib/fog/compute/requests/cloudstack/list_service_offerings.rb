module Fog
  module Compute
    class Cloudstack
      class Real

        def list_service_offerings(options={})
          options.merge!(
            'command' => 'listServiceOfferings'
          )
          
          request(options)
        end

      end
    end
  end
end
