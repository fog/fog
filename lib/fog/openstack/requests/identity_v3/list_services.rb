module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_services(options={})
            params = Hash.new
            params['type'] = options[:type] if options[:type]

            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

            request(
                :expects => [200],
                :method => 'GET',
                :path => "services",
                :query => params
            )
          end
        end

        class Mock
          def list_services

          end
        end
      end
    end
  end
end