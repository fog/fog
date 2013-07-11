require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Image < Fog::Model

        identity :name

        attribute :kind
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description
        attribute :preferred_kernel, :aliases => 'preferredKernel'
        attribute :project

        def reload
          requires :name

          data = {}

          # Try looking for the image in known projects
          [
            self.service.project,
            'google',
            'debian-cloud',
            'centos-cloud',
          ].each do |owner|
            begin
              data = service.get_image(name, owner).body
              data[:project] = owner
            rescue
            end
          end

          raise ArgumentError, 'Specified image was not found' if data.empty?

          self.merge_attributes(data)
          self
        end

        def save
          requires :name

          reload
        end

        def resource_url
          "#{self.project}/global/images/#{name}"
        end

      end
    end
  end
end
