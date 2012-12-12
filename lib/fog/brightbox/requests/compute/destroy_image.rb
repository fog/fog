module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the image.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#image_destroy_image
        #
        def destroy_image(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/images/#{identifier}", [202])
        end

      end
    end
  end
end
