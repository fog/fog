require 'fog/core/collection'
require 'fog/rackspace/models/databases/database'

module Fog
  module Rackspace
    class Databases
      class Databases < Fog::Collection
        model Fog::Rackspace::Databases::Database

        attr_accessor :instance

        def all
          load(retrieve_databases)
        end

        def get(database_name)
          data = retrieve_databases.find { |database| database['name'] == database_name }
          data && new(data)
        end

        private

        def retrieve_databases
          requires :instance
          data = service.list_databases(instance.id).body['databases']
        end
      end
    end
  end
end
