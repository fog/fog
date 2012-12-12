module Fog
  module Compute
    class Brightbox
      class Real
        # Update some details of the application.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name
        # @option options [String] :description
        #
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#application_update_application
        #
        def update_application(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request("put", "/1.0/applications/#{identifier}", [200], options)
        end

      end
    end
  end
end
