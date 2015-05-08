module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_users(options={})
            params = Hash.new
            params['domain_id'] = options[:domain_id] if options[:domain_id]
            params['name'] = options[:name] if options[:name]
            params['enabled'] = options[:enabled] if options[:enabled]

            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

            request(
                :expects => [200],
                :method => 'GET',
                :path => "users",
                :query => params
            )
          end
        end

        class Mock
          def list_users

          end
        end
      end
    end
  end
end