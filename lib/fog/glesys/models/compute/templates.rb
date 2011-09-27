require 'fog/core/collection'
require 'fog/glesys/models/compute/template'

module Fog
  module Compute
    class Glesys

      class Templates < Fog::Collection

        model Fog::Glesys::Compute::Template

        def all
          openvz = connection.template_list.body['response']['templates']['OpenVZ']
          xen    = connection.template_list.body['response']['templates']['Xen']

          load(xen+openvz)
        end

      end
    end
  end
end
