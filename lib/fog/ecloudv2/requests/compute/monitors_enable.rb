module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :monitors_enable, 202, 'POST'
      end

      class Mock
        def monitors_enable(service_uri)
          if vapp = mock_data.internet_service_from_href(service_uri)
            builder = Builder::XmlMarkup.new
            mock_it 200, builder.Task(xmlns)
          else
            mock_error 200, "401 Unauthorized"
          end
        end
      end
    end
  end
end
