require 'fog/core/model'

module Fog
  module Compute
    class Brightbox
      class DatabaseSnapshot < Fog::Model
        identity :id
        attribute :url
        attribute :resource_type

        attribute :name
        attribute :description
        attribute :state, :aliases => "status"

        attribute :database_engine
        attribute :database_version

        attribute :size

        attribute :created_at, :type => :time
        attribute :updated_at, :type => :time
        attribute :deleted_at, :type => :time

        def save
          options = {
            :name => name,
            :description => description
          }
          data = update_database_snapshot(options)
          merge_attributes(data)
          true
        end

        def ready?
          state == "available"
        end

        def destroy
          requires :identity
          merge_attributes(service.destroy_database_snapshot(identity))
          true
        end

        private

        def update_database_snapshot(options)
          service.update_database_snaphot(identity, options)
        end
      end
    end
  end
end
