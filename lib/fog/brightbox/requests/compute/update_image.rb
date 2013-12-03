module Fog
  module Compute
    class Brightbox
      class Real
        # Update some details of the image.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name
        # @option options [String] :username
        # @option options [String] :arch
        # @option options [String] :status
        # @option options [Boolean] :public
        # @option options [Boolean] :compatibility_mode
        # @option options [String] :description
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#image_update_image
        #
        def update_image(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/images/#{identifier}", [200], options)
        end

      end
    end
  end
end
