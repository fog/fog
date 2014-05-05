module Fog
  module XML
    class Connection < SAXParserConnection
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
