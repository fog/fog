require 'fog/core/model'
require 'fog/hp/models/compute_v2/metadata'

module Fog
  module Compute
    class HPV2
      class Image < Fog::Model
        identity :id

        attribute :name
        attribute :created_at,  :aliases => 'created'
        attribute :updated_at,  :aliases => 'updated'
        attribute :progress
        attribute :status
        attribute :server
        attribute :links
        #attribute :metadata        # lazy load metadata as needed per model

        def metadata
          @metadata ||= begin
            Fog::Compute::HPV2::Metadata.new({
              :service => service,
              :parent => self
            })
          end
        end

        def metadata=(new_metadata={})
          metas = []
          new_metadata.each_pair {|k,v| metas << {'key' => k, 'value' => v} }
          metadata.load(metas)
        end

        def destroy
          requires :id
          service.delete_image(id)
          true
        end

        def ready?
          status == 'ACTIVE'
        end

        # The following are built-in metadata for each image, exposed as helpers
        def bootable_volume?
          m = @metadata.find {|md| md.key == 'com.hp__1__bootable_volume'}
          m.value unless m.nil?
        end

        def provider
          m = @metadata.find {|md| md.key == 'com.hp__1__provider'}
          m.value unless m.nil?
        end

        def os_distro
          m = @metadata.find {|md| md.key == 'com.hp__1__os_distro'}
          m.value unless m.nil?
        end

        def os_version
          m = @metadata.find {|md| md.key == 'com.hp__1__os_version'}
          m.value unless m.nil?
        end

        def license
          m = @metadata.find {|md| md.key == 'hp_image_license'}
          m.value unless m.nil?
        end

        def type
          m = @metadata.find {|md| md.key == 'com.hp__1__image_type'}
          m.value unless m.nil?
        end

        def architecture
          m = @metadata.find {|md| md.key == 'architecture'}
          m.value unless m.nil?
        end
      end
    end
  end
end
