require "fog/core/collection"
require "fog/brightbox/models/compute/collaboration"

module Fog
  module Compute
    class Brightbox
      class Collaborations < Fog::Collection
        model Fog::Compute::Brightbox::Collaboration

        def all
          data = connection.list_collaborations
          load(data)
        end

        def destroy
          requires :identity
          connection.destroy_collaboration(identity)
          true
        end
      end
    end
  end
end
