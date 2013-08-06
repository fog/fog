require 'fog/core/collection'
require 'fog/google/models/compute/image'

module Fog
  module Compute
    class Google

      class Images < Fog::Collection

        model Fog::Compute::Google::Image

        def all
          data = []
          [ self.service.project,
            'google',
            'debian-cloud',
            'centos-cloud',
          ].each do |project|
            data += service.list_images(project).body["items"]
          end
          load(data)
        end

        def get(identity)
          data = connection.get_image(identity).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
