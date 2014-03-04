module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def monitors_create_http(data)
          validate_data([:interval, :response_timeout, :retries, :downtime, :enabled, :request_uri, :response_codes], data)

          request(
            :body => generate_http_monitor_request(data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_http_monitor_request(data)
          xml = Builder::XmlMarkup.new
          xml.CreateHttpMonitor do
            xml.Interval data[:interval]
            xml.ResponseTimeout data[:response_timeout]
            xml.Retries data[:retries]
            xml.Downtime data[:downtime]
            xml.Enabled data[:enabled]
            xml.RequestUri data[:request_uri]
            if data[:http_headers]
              xml.HttpHeaders data[:http_headers]
            end
            xml.ResponseCodes do
              data[:response_codes].each do |c|
                xml.ResponseCode c
              end
            end
          end
        end
      end
    end
  end
end
