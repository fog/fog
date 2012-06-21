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
          connection.create_database(instance.identity, identity, :character_set => character_set, :collate => collate)
          true
        end

        def destroy
          requires :identity, :instance
          connection.delete_database(instance.identity, identity)
          true
        end

        private

        def instance
          collection.instance
        end
      end
    end
  end
end
