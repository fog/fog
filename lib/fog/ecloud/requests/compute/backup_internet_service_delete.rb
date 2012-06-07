module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :backup_internet_service_delete, 202, 'DELETE'
      end

      class Mock
        def backup_internet_service_delete(uri)
          if vapp = mock_data.backup_internet_service_from_href(uri)
            backup_internet_service.delete!

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
