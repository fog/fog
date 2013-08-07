require "fog/core/collection"
require "fog/brightbox/models/compute/collaboration"

module Fog
  module Compute
    class Brightbox
      class Collaborations < Fog::Collection
        model Fog::Compute::Brightbox::Collaboration

        def all
          data = service.list_collaborations
          load(data)
        end

        def destroy
          requires :identity
          service.destroy_collaboration(identity)
          true
        end
      end
    end
  end
end
