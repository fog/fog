require 'fog/core/collection'
require 'fog/openstack/models/identity/user'

module Fog
  module Identity
    class OpenStack
      class Users < Fog::Collection
        model Fog::Identity::OpenStack::User

        def all
          load(connection.list_users.body['users'])
        end
      end # class Users
    end # class OpenStack
  end # module Identity
end # module Fog
