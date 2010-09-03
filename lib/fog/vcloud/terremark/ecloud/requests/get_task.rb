module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_task
        end

        module Mock
          def get_task(task__uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
