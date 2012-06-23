require 'fog/core/collection'
require 'fog/rackspace/models/identity/credential'

module Fog
  module Rackspace
    class Identity
      class Credentials < Fog::Collection

        model Fog::Rackspace::Identity::Credential

        attr_accessor :user

        def all
          requires :user
          load(retrieve_credentials)
        end

        def get(id)
          requires :user
          data = retrieve_credentials.find{ |credential| credential['id'] == id }
          data && new(data)
        end

        private

        def retrieve_credentials
          data = connection.list_credentials(user.identity).body['credentials']
        end
      end
    end
  end
end
