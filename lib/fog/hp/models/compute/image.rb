require 'fog/core/model'
require 'fog/openstack/models/compute/metadata'

module Fog
  module Compute
    class HP

      class Image < Fog::Model

        identity :id

        attribute :name
        attribute :created_at,  :aliases => 'created'
        attribute :updated_at,  :aliases => 'updated'
        attribute :progress
        attribute :status
        attribute :minDisk,     :aliases => 'min_disk'
        attribute :minRam,      :aliases => 'min_ram'
        attribute :server
        attribute :metadata
        attribute :links

        def initialize(attributes)
          @connection = attributes[:connection]
          super
        end

        def metadata
          @metadata ||= begin
            Fog::Compute::HP::Metadata.new({
              :connection => connection,
              :parent => self
            })
          end
        end

        def metadata=(new_metadata={})
          metas = []
          new_metadata.each_pair {|k,v| metas << {"key" => k, "value" => v} }
          metadata.load(metas)
        end

        def destroy
          requires :id

          connection.delete_image(id)
          true
        end

        def ready?
          status == 'ACTIVE'
        end

      end

    end
  end
end
