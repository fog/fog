module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_domains(options={})
            params = Hash.new
            params['name'] = options[:name] if options[:name]
            params['enabled'] = options[:enabled] if options[:enabled]

            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

            request(
                :expects => [200],
                :method => 'GET',
                :path => "domains",
                :query => params
            )
          end
        end

        class Mock
          def list_domains

          end
        end
      end
    end
  end
end