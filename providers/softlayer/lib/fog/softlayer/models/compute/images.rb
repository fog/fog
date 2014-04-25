#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#
require 'fog/core/collection'
require 'fog/softlayer/models/compute/image'

module Fog
  module Compute
    class Softlayer

      class Images < Fog::Collection

        model Fog::Compute::Softlayer::Image

        # Returns an array of all public images.
        #
        # Fog::Softlayer.images.all
        def all
          load(service.request(:virtual_guest_block_device_template_group, :get_public_images).body)
          self
        end

        # Used to retrieve an image
        def get(uuid)
          self.class.new(:service => service).all.detect {|image| image.id == uuid}
        end

      end

    end
  end
end
