module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_policies(options={})
            params = Hash.new
            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

            request(
                :expects => [200],
                :method => 'GET',
                :path => "policies",
                :query => params
            )
          end
        end

        class Mock
          def list_policies

          end
        end
      end
    end
  end
end