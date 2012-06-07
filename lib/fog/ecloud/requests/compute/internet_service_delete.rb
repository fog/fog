module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :internet_service_delete, 202, 'DELETE'
      end

      class Mock
        def internet_service_delete(vapp_uri)
          if vapp = mock_data.node_from_href(vapp_uri)
            vapp.delete!

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
