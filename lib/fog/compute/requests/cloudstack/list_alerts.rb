module Fog
  module Compute
    class Cloudstack
      class Real

        def list_alerts(options={})
          options.merge!(
            'command' => 'listAlerts'
          )
          
          request(options)
        end

      end
    end
  end
end
