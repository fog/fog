require 'fog/core/collection'
require 'fog/glesys/models/compute/template'

module Fog
  module Compute
    class Glesys
      class Templates < Fog::Collection
        model Fog::Compute::Glesys::Template

        def all
          # Only select OpenVZ and Xen platforms
          # Glesys only offers Xen and OpenVZ but they have other platforms in the list
          images = platform :openvz, :xen
          load(images)
        end

        def openvz
          images = platform :openvz
          load(images)
        end

        def xen
          images = platform :xen
          load(images)
        end

        private

        def platform(*platforms)
          images = service.template_list.body['response']['templates']
          images.select do |platform, images|
            platforms.include?(platform.downcase.to_sym)
          end.map{|platform, images| images}.flatten
        end
      end
    end
  end
end
