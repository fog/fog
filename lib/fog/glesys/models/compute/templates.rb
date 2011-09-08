require 'fog/core/collection'
require 'fog/glesys/models/compute/template'

module Fog
  module Compute
    class Glesys

      class Templates < Fog::Collection

        model Fog::Glesys::Compute::Template

        #attribute :platform
        #attribute :name
        #attribute :os
        #attribute :min_mem_size
        #attribute :min_disk_size

        def all
          openvz = connection.template_list.body['response']['templates']['OpenVZ']
          xen    = connection.template_list.body['response']['templates']['Xen']

          load(xen+openvz)
        end

      end
    end
  end
end
