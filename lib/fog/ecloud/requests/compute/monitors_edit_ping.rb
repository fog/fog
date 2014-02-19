module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def monitors_edit_ping(data)
          validate_data([:interval, :response_timeout, :retries, :downtime, :enabled], data)

          request(
            :body => generate_edit_ping_request(data),
            :expects => 200,
            :method => "PUT",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_edit_ping_request(data)
          xml = Builder::XmlMarkup.new
          xml.PingMonitor do
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
