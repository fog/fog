module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_task_list
        end

        module Mock
          def get_task_list(task_list_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end

