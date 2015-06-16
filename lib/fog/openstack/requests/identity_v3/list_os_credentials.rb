module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_os_credentials(options={})
            params = Hash.new
            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)
            params['user_id'] = options[:user_id] if options[:user_id]

            request(
                :expects => [200],
                :method => 'GET',
                :path => "credentials",
                :query => params
            )
          end
        end

        class Mock
          def list_os_credentials

          end
        end
      end
    end
  end
end