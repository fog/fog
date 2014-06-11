require 'fog/core/model'

module Fog
  module Compute
    class Google
      class Image < Fog::Model
        identity :name

        attribute :id
        attribute :kind
        attribute :archive_size_bytes, :aliases => 'archiveSizeBytes'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :deprecated
        attribute :description
        attribute :disk_size_gb, :aliases => 'diskSizeGb'
        attribute :self_link, :aliases => 'selfLink'
        attribute :source_type, :aliases => 'sourceType'
        attribute :status

        # This attribute is not available in the representation of an
        # 'image' returned by the GCE servser (see GCE API). However,
        # images are a global resource and a user can query for images
        # across projects. Therefore we try to remember which project
        # the image belongs to by tracking it in this attribute.
        attribute :project

        # A RawDisk, e.g. -
        # {
        #   :source         => url_to_gcs_file,
        #   :container_type => 'TAR',
        #   :sha1Checksum   => ,
        # }
        attribute :raw_disk, :aliases => 'rawDisk'

        def preferred_kernel=(args)
          Fog::Logger.deprecation("preferred_kernel= is no longer used [light_black](#{caller.first})[/]")
        end

        def preferred_kernel
          Fog::Logger.deprecation("preferred_kernel is no longer used [light_black](#{caller.first})[/]")
          nil
        end

        READY_STATE = "READY"

        def ready?
          self.status == READY_STATE
        end

        def destroy(async=true)
          data = service.delete_image(name)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'])
          unless async
            operation.wait_for { ready? }
          end
          operation
        end

        def reload
          requires :name

          self.project = self.service.project
          data = service.get_image(name, self.project).body

          self.merge_attributes(data)
          self
        end

        def save
          requires :name
          requires :raw_disk

          options = {
            'rawDisk'         => raw_disk,
            'description'     => description,
          }

          data = service.insert_image(name, options)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'])
          operation.wait_for { !pending? }
          reload
        end

        def resource_url
          "#{self.project}/global/images/#{name}"
        end
      end
    end
  end
end
