module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def list_roles(options={})
            params = Hash.new
            params['name'] = options[:name] if options[:name]

            params['page'] = options.fetch(:page, 1)
            params['per_page'] = options.fetch(:per_page, 30)

#          if params['user_id'] then
# Returns 404 "The resource could not be found."
# https://bugs.launchpad.net/keystone/+bug/933565 reports this - bug is set to "Won't fix"
#   user_id = params.delete 'user_id'
#   request(
#       :expects => [200],
#       :method  => 'GET',
#       :path    => "users/#{user_id}/roles",
#       :query   => params
#   )
# else
            request(
                :expects => [200],
                :method => 'GET',
                :path => "roles",
                :query => params
            )
#          end
          end
        end

        class Mock
          def list_roles

          end
        end
      end
    end
  end
end