module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_projects(options={})
            params = Hash.new
            params['user_id'] = options[:user_id] if options[:user_id]
            params['domain_id'] = options[:domain_id] if options[:domain_id]
            params['name'] = options[:name] if options[:name]
            params['enabled'] = options[:enabled] if options[:enabled]

            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

            if params['user_id'] then
              request(
                  :expects => [200],
                  :method => 'GET',
                  :path => "users/#{params['user_id']}/projects",
                  :query => params
              )
            else
              request(
                  :expects => [200],
                  :method => 'GET',
                  :path => "projects",
                  :query => params
              )
            end
          end
        end

        class Mock
          def list_projects

          end
        end
      end
    end
  end
end