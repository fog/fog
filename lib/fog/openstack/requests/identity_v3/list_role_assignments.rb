module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_role_assignments(options={})
            params = Hash.new
            params['group.id'] = options[:group_id] if options[:group_id]
            params['role.id'] = options[:role_id] if options[:role_id]
            params['scope.domain.id'] = options[:domain_id] if options[:domain_id]
            params['scope.project.id'] = options[:project_id] if options[:project_id]
            params['user.id'] = options[:user_id] if options[:user_id]
            params['effective'] = options[:effective] if options[:effective]

            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

            request(
                :expects => [200],
                :method => 'GET',
                :path => "role_assignments",
                :query => params
            )
          end
        end

        class Mock
          def list_role_assignments

          end
        end
      end
    end
  end
end