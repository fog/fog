module Fog
  module Cloudkick
    class Monitoring
      class Real

        def enable_monitor(monitor_id)
          request(
            :headers  => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :expects  => [204],
            :method   => 'POST',
            :path     => "/#{API_VERSION}/monitor/#{monitor_id}/enable"
          )
        end

      end

      class Mock

        def enable_monitor(monitor_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
