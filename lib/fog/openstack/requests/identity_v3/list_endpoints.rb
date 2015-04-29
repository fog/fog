module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_endpoints(options={})
            params = Hash.new
            params['service_id'] = options[:service_id] if options[:service_id]
            params['interface'] = options[:interface] if options[:interface]

            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

            request(
                :expects => [200],
                :method => 'GET',
                :path => "endpoints",
                :query => params
            )
          end
        end

        class Mock
          def list_endpoints

          end
        end
      end
    end
  end
end