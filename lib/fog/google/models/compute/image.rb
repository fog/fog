require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Image < Fog::Model

        identity :name

        attribute :id
        attribute :kind
        attribute :self_link, :aliases => 'selfLink'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :deprecated
        attribute :description

        # This attribute is not available in the representation of an
        # 'image' returned by the GCE servser (see GCE API). However,
        # images are a global resource and a user can query for images
        # across projects. Therefore we try to remember which project
        # the image belongs to by tracking it in this attribute.
        attribute :project

        # a RawDisk - link to Google Storage file with disk.raw archive
        # TODO: think if you can use Fog::Storage::Google::File here.
        attribute :raw_disk

        attribute :status

        def preferred_kernel=(args)
          Fog::Logger.deprecation("preferred_kernel= is no longer used [light_black](#{caller.first})[/]")
        end
        def preferred_kernel
          Fog::Logger.deprecation("preferred_kernel is no longer used [light_black](#{caller.first})[/]")
          nil
        end

        def reload
          requires :name

          data = service.get_image(name, self.project).body

          self.merge_attributes(data)
          self
        end

        def save
          requires :name
          requires :raw_disk

          options = { 'description' => description }

          response = service.insert_image(name, raw_disk, options)
          
          operation = service.operations.new(response.body)
          operation.wait

          data = service.backoff_if_unfound {
            service.get_image(self.name).body
          }

          # Track the name of the project in which we insert the image
          data.merge!('project' => service.project)
          
          self.project = self.service.project

          service.images.merge_attributes(data)
        end

        def resource_url
          "#{self.project}/global/images/#{name}"
        end

        def delete
          requires :name

          response = service.delete_image(name)

          operation = service.operations.new(response.body)
          operation.wait          
        end

      end
    end
  end
end
