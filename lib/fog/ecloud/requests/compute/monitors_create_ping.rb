module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def monitors_create_ping(data)
          validate_data([:interval, :response_timeout, :retries, :downtime, :enabled], data)

          request(
            :body => generate_ping_monitor_request(data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_ping_monitor_request(data)
          xml = Builder::XmlMarkup.new
          xml.CreatePingMonitor do
            xml.Interval data[:interval]
            xml.ResponseTimeout data[:response_timeout]
            xml.Retries data[:retries]
            xml.Downtime data[:downtime]
            xml.Enabled data[:enabled]
          end
        end
      end
    end
  end
end
