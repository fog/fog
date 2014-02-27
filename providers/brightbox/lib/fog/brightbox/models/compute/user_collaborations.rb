require "fog/core/collection"
require "fog/brightbox/models/compute/user_collaboration"

module Fog
  module Compute
    class Brightbox
      class UserCollaborations < Fog::Collection
        model Fog::Compute::Brightbox::UserCollaboration

        def all
          data = service.list_user_collaborations
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_user_collaboration(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def destroy
          requires :identity
          service.destroy_user_collaboration(identity)
          true
        end
      end
    end
  end
end
