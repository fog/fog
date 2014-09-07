module Fog
  # @note Extracting XML components out of core is a work in progress.
  #
  # The {XML} module includes functionality that is common between APIs using
  # XML to send and receive data.
  #
  # The intent is to provide common code for provider APIs using XML but not
  # require it for those using JSON.
  #
  # @todo Add +require "fog/xml"+ and/or +include Fog::XML+ to providers using
  #   its services
  #
  module XML
    class Connection < Fog::XML::SAXParserConnection
      def request(params, &block)
        if (parser = params.delete(:parser))
          super(parser, params)
        else
          original_request(params)
        end
      end
    end
  end
end
