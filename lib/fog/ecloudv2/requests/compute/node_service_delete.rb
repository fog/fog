module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :node_service_delete, 202, 'DELETE'
      end

      class Mock
        def node_service_delete(vapp_uri)
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
