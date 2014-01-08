require 'fog/core/collection'
require 'fog/google/models/compute/image'

module Fog
  module Compute
    class Google

      class Images < Fog::Collection

        model Fog::Compute::Google::Image

        GLOBAL_PROJECTS = [ 'google',
                            'debian-cloud',
                            'centos-cloud',
                          # RHEL removed from this list because not everyone has access to it.
                          #  'rhel-cloud', 
                          ]

        def all
          data = []
          all_projects = GLOBAL_PROJECTS + [ self.service.project ]

          all_projects.each do |project|
            images = service.list_images(project).body["items"] || []

            # Keep track of the project in which we found the image(s)
            images.each { |img| img[:project] = project }
            data += images
          end

          load(data)
        end

        def get(identity)
          # Search own project before global projects
          all_projects = [ self.service.project ] + GLOBAL_PROJECTS

          data = nil
          all_projects.each do |project|
            begin
              data = service.get_image(identity, project).body
              data[:project] = project
            rescue Fog::Errors::Error
              next
            else
              break
            end
          end

          # If it wasn't found in any project, raise
          if data.nil?
            raise Fog::Errors::Error.new('Unable to find the specified image '\
                                         'in the following projects: '\
                                         "#{all_projects.join(', ')}")
          end

          new(data)
        end

      end
    end
  end
end
