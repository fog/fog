module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def monitors_create_ecv(data)
          validate_data([:interval, :response_timeout, :retries, :downtime, :enabled, :send_string, :receive_string], data)

          request(
            :body => generate_ecv_monitor_request(data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_ecv_monitor_request(data)
          xml = Builder::XmlMarkup.new
          xml.CreateEcvMonitor do
            xml.Interval data[:interval]
            xml.ResponseTimeout data[:response_timeout]
            xml.Retries data[:retries]
            xml.Downtime data[:downtime]
            xml.Enabled data[:enabled]
            xml.SendString data[:send_string]
            if data[:http_headers]
              xml.HttpHeaders data[:http_headers]
            end
            xml.ReceiveString data[:receive_string]
          end
        end
      end
    end
  end
end
