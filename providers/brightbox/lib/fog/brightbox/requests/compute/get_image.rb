module Fog
  module Compute
    class Brightbox
      class Real
        # Get full details of the image.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#image_get_image
        #
        def get_image(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/images/#{identifier}", [200])
        end
      end
    end
  end
end
