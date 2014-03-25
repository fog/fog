module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def monitors_edit_http(data)
          validate_data([:interval, :response_timeout, :retries, :downtime, :enabled, :request_uri, :response_codes], data)

          request(
            :body => generate_edit_http_request(data),
            :expects => 200,
            :method => "PUT",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_edit_http_request(data)
          xml = Builder::XmlMarkup.new
          xml.HttpMonitor do
            xml.Interval data[:interval]
            xml.ResponseTimeout data[:response_timeout]
            xml.Retries data[:retries]
            xml.Downtime data[:downtime]
            xml.Enabled data[:enabled]
            xml.RequestUri data[:request_uri]
            if xml[:httpheaders]
              xml.HttpHeaders xml[:http_headers]
            end
            xml.ResponseCodes do
              xml[:response_codes].each do |c|
                xml.ResponseCode c
              end
            end
          end
        end
      end
    end
  end
end
