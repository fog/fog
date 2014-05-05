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

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_collaboration(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        # Invites a user (via an email) to collaborate on the currently scoped
        # account at the +role+ level.
        #
        # @param [String] email The email address to use for the invitation
        # @param [String] role The role being granted. Only (+admin+ is
        #   currently supported
        # @return [Fog::Compute::Brightbox::Collaboration]
        #
        def invite(email, role)
          return nil if email.nil? || email == ""
          return nil if role.nil? || role == ""
          options = { :email => email, :role => role }
          data = service.create_collaboration(options)
          new(data)
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
