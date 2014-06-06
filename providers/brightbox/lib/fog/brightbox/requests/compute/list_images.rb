module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of images available for use by the Account. It includes those available to all customers
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#image_list_images
        #
        def list_images
          wrapped_request("get", "/1.0/images", [200])
        end
      end
    end
  end
end
