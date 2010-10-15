module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :power_on, 202, 'POST'
        end

        class Mock
          def power_on(vapp_uri)
            vapp, vdc = vapp_and_vdc_from_vapp_uri(vapp_uri)

            if vapp
              vapp[:status] = 4

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
end
