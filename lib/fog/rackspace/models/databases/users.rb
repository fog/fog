require 'fog/core/collection'
require 'fog/rackspace/models/databases/user'

module Fog
  module Rackspace
    class Databases
      class Users < Fog::Collection
        model Fog::Rackspace::Databases::User

        attr_accessor :instance

        def all
          load(retrieve_users)
        end

        def get(user_name)
          data = retrieve_users.find { |database| database['name'] == user_name }
          data && new(data)
        end

        private

        def retrieve_users
          requires :instance
          data = service.list_users(instance.identity).body['users']
        end
      end
    end
  end
end
