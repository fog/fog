require 'fog/core/model'

module Fog
  module Rackspace
    class Databases
      class Database < Fog::Model
        identity :name

        attribute :character_set
        attribute :collate

        def save
          requires :identity, :instance
          service.create_database(instance.identity, identity, :character_set => character_set, :collate => collate)
          true
        end

        def destroy
          requires :identity, :instance
          service.delete_database(instance.identity, identity)
          true
        end

        def grant_access_for(user)
          requires :identity, :instance
          service.grant_user_access(instance.identity, user, name)
        end

        def revoke_access_for(user)
          requires :identity, :instance
          service.revoke_user_access(instance.identity, user, name)
        end


        private

        def instance
          collection.instance
        end
      end
    end
  end
end
