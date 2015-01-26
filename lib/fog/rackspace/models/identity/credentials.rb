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
          data = retrieve_credentials.find { |credential| credential['apiKey'] == id }
          data && new(data)
        end

        private

        def retrieve_credentials
          raw_credentials = service.list_credentials(user.identity).body['credentials']
          raw_credentials.map { |c| c['RAX-KSKEY:apiKeyCredentials'] }
        end
      end
    end
  end
end
