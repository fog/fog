module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :virtual_machine_delete, 202, 'DELETE'
      end

      class Mock
        def delete(uri)
          if vapp = mock_data.virtual_machine_from_href(uri)
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
