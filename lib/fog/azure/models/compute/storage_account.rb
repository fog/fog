require "fog/compute/models/server"
require "net/ssh/proxy/command"
require "tempfile"

module Fog
  module Compute
    class Azure
      class StorageAccount < Fog::Model
        identity :name
        attribute :url
        attribute :description
        attribute :affinity_group
        attribute :location
        attribute :label
        attribute :status
        attribute :endpoints
        attribute :geo_replication_enabled
        attribute :geo_primary_region
        attribute :status_of_primary
        attribute :last_geo_failover_time
        attribute :geo_secondary_region
        attribute :status_of_secondary
        attribute :creation_time
        attribute :extended_properties


        def save
          requires :name
          requires_one :location, :affinity_group

          options = {
            :label => label,
            :location => location,
            :description => description,
            :affinity_group_name => affinity_group,
            :geo_replication_enabled => geo_replication_enabled,
            :extended_properties => extended_properties,
          }

          service.create_storage_account(name, options)
        end

        def destroy
          requires :name
          service.delete_storage_account(name)
        end
      end
    end
  end
end
