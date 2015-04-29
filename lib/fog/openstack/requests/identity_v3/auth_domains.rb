module Fog
  module Identity
    class OpenStack
      class V3

        class Real
          def auth_domains(options={})
            params = Hash.new
            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

            request(
                :expects => [200],
                :method => 'GET',
                :path => "auth/domains",
                :query => params
            )
          end
        end

        class Mock
          def auth_domains

          end
        end
      end
    end
  end
end