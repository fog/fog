module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_group_users(id, options={})
            params = Hash.new
            params['name'] = options[:name] if options[:name]
            params['domain_id'] = options[:domain_id] if options[:domain_id]
            params['description'] = options[:description] if options[:description]

            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

            request(
                :expects => [200],
                :method => 'GET',
                :path => "groups/#{id}/users",
                :query => params
            )
          end
        end

        class Mock
          def list_group_users

          end
        end
      end
    end
  end
end