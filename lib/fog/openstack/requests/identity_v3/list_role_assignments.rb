module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_role_assignments(options = {})
            # Backwards compatibility name mapping
            name_mapping = {
              :group_id   => 'group.id',
              :role_id    => 'role.id',
              :domain_id  => 'scope.domain.id',
              :project_id => 'scope.project.id',
              :user_id    => 'user.id',
            }
            name_mapping.keys.each do |key|
              if (opt = options.delete(key))
                Fog::Logger.deprecation("Calling OpenStack[:keystone].list_role_assignments(options) with deprecated"\
                                        " option '#{key}'. Use option '#{name_mapping[key]}' which is defined in"\
                                        " keystone documentation.")
                options[name_mapping[key]] = opt
              end
            end

            request(
              :expects => [200],
              :method  => 'GET',
              :path    => "role_assignments",
              :query   => options
            )
          end
        end

        class Mock
          def list_role_assignments(options = {})

          end
        end
      end
    end
  end
end
