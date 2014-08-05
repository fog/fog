require 'fog/core/model'
require 'fog/hp/models/compute/metadata'

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
        attribute :server
        attribute :metadata
        attribute :links

        # these values are extracted from metadata
        attr_reader :min_disk
        attr_reader :min_ram
        attr_reader :image_type
        attr_reader :architecture

        def metadata
          @metadata ||= begin
            Fog::Compute::HP::Metadata.new({
              :service => service,
              :parent => self
            })
          end
        end

        def metadata=(new_metadata={})
          metas = []
          new_metadata.each_pair {|k,v| metas << {"key" => k, "value" => v} }
          metadata.load(metas)
        end

        def min_disk
          m = metadata.get("min_disk")
          m.value unless m.nil?
        end

        def min_ram
          m = metadata.get("min_ram")
          m.value unless m.nil?
        end

        def image_type
          m = metadata.get("image_type")
          m.value unless m.nil?
        end

        def architecture
          m = metadata.get("architecture")
          m.value unless m.nil?
        end

        def destroy
          requires :id
          service.delete_image(id)
          true
        end

        def ready?
          status == 'ACTIVE'
        end
      end
    end
  end
end
