require "fog/core/collection"
require "fog/brightbox/models/compute/user_collaboration"

module Fog
  module Compute
    class Brightbox
      class UserCollaborations < Fog::Collection
        model Fog::Compute::Brightbox::UserCollaboration

        def all
          data = connection.list_user_collaborations
          load(data)
        end

        def destroy
          requires :identity
          connection.destroy_user_collaboration(identity)
          true
        end
      end
    end
  end
end
