require 'fog/core/collection'
require 'fog/google/models/sql/instance'

module Fog
  module Google
    class SQL
      class Instances < Fog::Collection
        model Fog::Google::SQL::Instance

        ##
        # Lists all instance
        #
        # @return [Array<Fog::Google::SQL::Instance>] List of instance resources
        def all
          data = service.list_instances.body['items'] || []
          load(data)
        end

        ##
        # Retrieves an instance
        #
        # @param [String] instance_id Instance ID
        # @return [Fog::Google::SQL::Instance] Instance resource
        def get(instance_id)
          if instance = service.get_instance(instance_id).body
            new(instance)
          end
        rescue Fog::Errors::NotFound
          nil
        rescue Fog::Errors::Error => e
          # Google SQL returns a 403 if we try to access a non-existing resource
          # The default behaviour in Fog is to return a nil
          return nil if e.message == 'The client is not authorized to make this request.'
          raise e
        end
      end
    end
  end
end
