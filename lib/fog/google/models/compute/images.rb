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

        def get(identity,project=nil)
          response = nil
          if project.nil?
            [ self.service.project,
              'google',
              'debian-cloud',
              'centos-cloud',
            ].each do |project|
              begin
                response = connection.get_image(identity,project)
                break if response.status == 200
              rescue Fog::Errors::Error
              end
            end
          else
            response = connection.get_image(identity,project)
          end
          new(response.body)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
