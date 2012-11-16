module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of images available for use by the Account. It includes those available to all customers
        #
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#image_list_images
        #
        def list_images
          request("get", "/1.0/images", [200])
        end

      end
    end
  end
end
