require 'fog/core/collection'
require 'fog/glesys/models/compute/template'

module Fog
  module Compute
    class Glesys

      class Templates < Fog::Collection

        model Fog::Glesys::Compute::Template

        def all
          request = service.template_list.body
          templates = request['response']['templates']

          # Only select OpenVZ and Xen platforms
          # Glesys only offers Xen and OpenVZ but they have other platforms in the list
          templates = templates.select do |platform, templates|
            %w|openvz xen|.include?(platform.downcase)
          end.collect{|platform, templates| templates}.flatten

          load(templates)
        end

      end
    end
  end
end
