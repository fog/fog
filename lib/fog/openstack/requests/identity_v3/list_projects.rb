module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_projects(options = {})
            user_id = options.delete('user_id') || options.delete(:user_id)
            if user_id
              path = "users/#{user_id}/projects"
            else
              path = "projects"
            end

            request(
              :expects => [200],
              :method  => 'GET',
              :path    => path,
              :query   => options
            )
          end
        end

        class Mock
          def list_projects(options = {})

          end
        end
      end
    end
  end
end
